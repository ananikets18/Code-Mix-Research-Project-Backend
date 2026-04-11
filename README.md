# 🤖 Code-Mix Research Project — Backend

![License](https://img.shields.io/badge/License-MIT-blue.svg)
![Python](https://img.shields.io/badge/Python-3.9%2B-blue)
![Build](https://img.shields.io/badge/build-passing-brightgreen)

Welcome to the **backend engine** of the Code-Mix Research Project — a FastAPI-based NLP service designed to understand the multilingual, code-mixed reality of Indian social media text 🇮🇳🌍.

This backend powers the entire NLP pipeline for the frontend application, providing **language detection**, **sentiment analysis**, **toxicity detection**, **translation**, and **romanized Indic text conversion**.
All components are optimized for **speed**, **scalability**, and **multilingual accuracy**.

---

## 📌 Project Summary

Social media language in India is rarely monolingual. It is expressive, noisy, code-mixed, and often romanized.
This backend provides a research-focused yet production-ready NLP pipeline tailored specifically for these challenges.

It exposes fast, scalable APIs that intelligently route text through fine-tuned transformer models and translation pipelines, enabling accurate analysis of real-world multilingual data.

---

## ✨ Key Features

* Language detection for **2000+ languages**, including code-mixed inputs
* Sentiment analysis fine-tuned on Indic datasets
* Toxicity detection across **6 content categories**
* Automatic translation with intelligent source–target detection
* Romanized Indic text conversion to native scripts
* Batch processing and async inference support
* Redis-based caching for high-performance responses
* Easy local and Docker-based deployment

---

## 📚 Table of Contents

* [Tech Stack & Models](#-tech-stack--models)
* [Backend Optimizations](#-backend-optimizations)
* [Run Locally](#-run-locally)
* [API Endpoints](#-api-endpoints)
* [Example Requests](#-example-requests)
* [Example Response](#-example-response)
* [Why This Project Exists](#-why-this-project-exists)
* [Contributing](#-contributing)

---

## 🧠 Tech Stack & Models

| Component / Model           | Purpose                 | Details                                                      |
| --------------------------- | ----------------------- | ------------------------------------------------------------ |
| **GLotLID**                 | Language detection      | Detects 2000+ languages and code-mixed text                  |
| **Sentiment Models**        | Multilingual sentiment  | `xlm-roberta` and `indic-bert`, fine-tuned on Indic datasets |
| **Toxicity Classifier**     | Toxic content detection | XLM-RoBERTa-based, 6-category classification                 |
| **Translation Engine**      | Language translation    | Google Translate API via `googletrans`                       |
| **IndicNLP Library**        | Transliteration         | Romanized → native script using ITRANS                       |
| **Hybrid Conversion Logic** | Accuracy improvement    | Combines ITRANS with dictionary-based mapping                |
| **Romanized Text Handling** | Indic preprocessing     | Converts text before translation/inference                   |
| **Auto Language Routing**   | Smart inference         | Dynamically selects models per input                         |
| **Batch Translation**       | Multi-target output     | Supports simultaneous translations                           |

---

## ⚙️ Backend Optimizations

* ⚡ **Model Caching**
  Lightweight models load instantly, with full weights initialized in the background to reduce cold starts.

* 🧠 **Persistent In-Memory Models**
  Models remain loaded across requests, improving response times by **40–60%**.

* 🔁 **Redis Caching (Upstash)**

  * Endpoint-level caching (`/analyze`, `/translate`)
  * Smart TTL per request type
  * Automatic fallback to live inference on cache misses

* 🚀 **Async API Execution**
  FastAPI async I/O enables concurrent inference and batch handling under load.

---

## 🧩 Run Locally

```bash
git clone https://github.com/ananikets18/Code-Mix-Research-Project-Backend.git
cd Code-Mix-Research-Project-Backend

# Environment setup
cp .env.example .env
# Configure variables such as MODEL_PATH, REDIS_URL, API_KEYS, etc.

# Install dependencies
pip install -r requirements_api.txt

# Run the API
python api.py
```

The server will be available at:

```
http://127.0.0.1:8000
```

### Production (Docker)

```bash
docker compose up --build -d
```

---

## 🚀 API Endpoints

| Endpoint     | Method | Description                                               |
| ------------ | ------ | --------------------------------------------------------- |
| `/analyze`   | POST   | Full NLP pipeline (language, sentiment, toxicity, domain) |
| `/sentiment` | POST   | Sentiment-only analysis                                   |
| `/translate` | POST   | Language translation                                      |
| `/convert`   | POST   | Romanized → native script conversion                      |
| `/health`    | GET    | API health check                                          |

---

## 📝 Example Requests

### Analyze

```http
POST /analyze
Content-Type: application/json

{
  "text": "Yeh movie bahut awesome thi!"
}
```

### Translate

```http
POST /translate
Content-Type: application/json

{
  "text": "Mujhe pizza chahiye",
  "target_lang": "en"
}
```

### Health Check

```bash
curl http://127.0.0.1:8000/health
```

---

## 🧪 Example Response

```json
{
  "language": "hi-en",
  "sentiment": "positive",
  "toxicity": {
    "is_toxic": false,
    "categories": []
  },
  "translation": "This movie was very awesome!",
  "romanized_conversion": "यह मूवी बहुत ऑसम थी!"
}
```

---

## ❤️ Why This Project Exists

Indian social media language is rarely clean or monolingual — it is **code-mixed, contextual, and expressive**.
This backend exists to help researchers and developers work with that reality instead of ignoring it.

Built with curiosity, iteration, and a lot of testing.

---

## 🤝 Contributing

Contributions are welcome and appreciated.

* Fork the repository and create a branch from `main`
* Update documentation for any API or environment changes
* Keep commits clear and focused
* Test endpoints before submitting a PR


