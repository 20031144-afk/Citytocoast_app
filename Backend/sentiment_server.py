import pandas as pd
from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer

# Load dataset once
# df = pd.read_csv("IMDB Dataset.csv")

# Initialize VADER
analyzer = SentimentIntensityAnalyzer()

def analyze_text(text: str):
    """Analyze a single text input"""
    return analyzer.polarity_scores(text)
