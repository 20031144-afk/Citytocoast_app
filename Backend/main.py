import json
import os
from fastapi import FastAPI, Body, HTTPException
from sentiment_server import analyze_text
from datetime import datetime

app = FastAPI()

REVIEWS_FILE = "reviews.json"


# --------------------------
# Helpers
# --------------------------
def load_reviews():
    """Load reviews from file, return empty list if missing/corrupted."""
    if not os.path.exists(REVIEWS_FILE):
        return []
    try:
        with open(REVIEWS_FILE, "r", encoding="utf-8") as f:
            return json.load(f)
    except (json.JSONDecodeError, UnicodeDecodeError):
        return []


def save_reviews(reviews):
    """Save reviews back to file."""
    with open(REVIEWS_FILE, "w", encoding="utf-8") as f:
        json.dump(reviews, f, indent=2, ensure_ascii=False )


# --------------------------
# Endpoints
# --------------------------
@app.get("/reviews")
def get_reviews():
    try:
        reviews = load_reviews()

        # ✅ Validate & skip broken reviews
        valid_reviews = []
        for r in reviews:
            if "date" not in r or "text" not in r:
                continue
            try:
                _ = datetime.fromisoformat(r["date"])  # validate ISO date
                valid_reviews.append(r)
            except Exception:
                continue

        # ✅ Sort by newest date
        valid_reviews.sort(key=lambda r: datetime.fromisoformat(r["date"]), reverse=True)

        analyzed = []
        for r in valid_reviews:
            try:
                scores = analyze_text(r["text"])
                compound = scores.get("compound", 0)
                if compound >= 0.05:
                    sentiment = "positive"
                elif compound <= -0.05:
                    sentiment = "negative"
                else:
                    sentiment = "neutral"
                analyzed.append({**r, "sentiment": sentiment, "scores": scores})
            except Exception as e:
                print(f"⚠️ Skipping review {r} due to error: {e}")
                continue

        return analyzed
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error fetching reviews: {e}")


@app.post("/add_review")
def add_review(
    user: str = Body(...),
    img: str = Body(...),
    text: str = Body(...),
    date: str = Body(...),
):
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
        try:
            text = r.get("text", "").strip()
            if not text:
                continue
            scores = analyze_text(text)
            c = scores.get("compound", 0)
            if c >= 0.05:
                positive += 1
            elif c <= -0.05:
                negative += 1
            else:
                neutral += 1
        except Exception as e:
            print(f"⚠️ Skipping review {r} due to error: {e}")
            continue

    return {
        "total_reviews": total,
        "positive_percent": round((positive / total) * 100, 2) if total else 0,
        "neutral_percent": round((neutral / total) * 100, 2) if total else 0,
        "negative_percent": round((negative / total) * 100, 2) if total else 0,
        "new_users": 12,  # mock for now
        "total_reactions": 47,  # mock for now
    }


@app.get("/")
def root():
    return {"message": "Sentiment Analysis API running"}
