# model_downloader.py
# Utility to check if ML models are present on disk
import os

expected_model_folders = [
    "ai4bharatIndicBERTv2-alpha-SentimentClassification",
    "cardiffnlptwitter-xlm-roberta-base-sentiment",
    "cis-lmuglotlid",
    "oleksiizirka-xlm-roberta-toxicity-classifier"
]

def all_models_present():
    """Check if all required ML model folders exist."""
    return all(os.path.isdir(folder) for folder in expected_model_folders)

def get_missing_models():
    """Return list of missing model folder names."""
    return [folder for folder in expected_model_folders if not os.path.isdir(folder)]
