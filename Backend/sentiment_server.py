import pandas as pd
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

# Load dataset once
df = pd.read_csv("IMDB Dataset.csv")

# Initialize VADER
analyzer = SentimentIntensityAnalyzer()

def analyze_text(text: str):
    """Analyze a single text input"""
    return analyzer.polarity_scores(text)

def analyze_review_by_index(index: int):
    """Analyze review from dataset by index"""
    if index < 0 or index >= len(df):
        return {"error": "Index out of range"}
    
    text = df['review'][index]
    scores = analyzer.polarity_scores(text)
    return {"review": text, "sentiment": scores}
