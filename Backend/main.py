import json
from fastapi import FastAPI, Body
from sentiment_server import analyze_text
from datetime import datetime

app = FastAPI()

REVIEWS_FILE = "reviews.json"

def load_reviews():
    with open(REVIEWS_FILE, "r") as f:
        return json.load(f)

def save_reviews(reviews):
    with open(REVIEWS_FILE, "w") as f:
        json.dump(reviews, f, indent=2)

@app.get("/reviews")
def get_reviews():
    reviews = load_reviews()

    # ✅ Sort reviews by date (newest first)
    reviews.sort(key=lambda r: datetime.fromisoformat(r["date"]), reverse=True)

    analyzed = []
    for r in reviews:
        scores = analyze_text(r["text"])
        compound = scores["compound"]
        if compound >= 0.05:
            sentiment = "positive"
        elif compound <= -0.05:
            sentiment = "negative"
        else:
            sentiment = "neutral"
        analyzed.append({**r, "sentiment": sentiment, "scores": scores})
    return analyzed

@app.post("/add_review")
def add_review(user: str = Body(...), img: str = Body(...), text: str = Body(...), date: str = Body(...)):
    reviews = load_reviews()
    new_review = {"user": user, "img": img, "text": text, "date": date}
    reviews.append(new_review)
    save_reviews(reviews)
    return {"message": "Review added successfully"}

@app.get("/summary")
def summary():
    reviews = load_reviews()
    total = len(reviews)
    positive = neutral = negative = 0
    for r in reviews:
        scores = analyze_text(r["text"])
        c = scores["compound"]
        if c >= 0.05:
            positive += 1
        elif c <= -0.05:
            negative += 1
        else:
            neutral += 1
    return {
        "total_reviews": total,
        "positive_percent": round((positive / total) * 100, 2) if total else 0,
        "neutral_percent": round((neutral / total) * 100, 2) if total else 0,
        "negative_percent": round((negative / total) * 100, 2) if total else 0,
        "new_users": 12,   # mock for now
        "total_reactions": 47  # mock for now
    }

@app.get("/")
def root():
    return {"message": "Sentiment Analysis API running"}
