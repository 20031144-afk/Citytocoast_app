from fastapi import FastAPI
from pydantic import BaseModel
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer
from sentiment_server import analyze_text, analyze_review_by_index


# Initialize FastAPI app
app = FastAPI()

# Initialize the sentiment analyzer
analyzer = SentimentIntensityAnalyzer()

# Request model
class SentimentRequest(BaseModel):
    text: str

# Response model
class SentimentResponse(BaseModel):
    sentiment: str
    scores: dict

@app.post("/analyze", response_model=SentimentResponse)
def analyze_sentiment(request: SentimentRequest):
    # Get sentiment scores
    scores = analyzer.polarity_scores(request.text)

    # Determine overall sentiment label
    compound = scores["compound"]
    if compound >= 0.05:
        sentiment = "positive"
    elif compound <= -0.05:
        sentiment = "negative"
    else:
        sentiment = "neutral"

    return {"sentiment": sentiment, "scores": scores}

@app.get("/")
def root():
    return {"message": "Sentiment Analysis API is running"}
