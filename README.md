# LLM Evaluations

Evaluation experiments for ML and LLM models — hands-on PyTorch implementations and transformer benchmarking from technical interviews.

## Overview

This repository contains practical machine learning work demonstrating:

- **Neural network construction from scratch** using PyTorch (`nn.Module`, `nn.Parameter`)
- **Training loops** with SGD, loss computation, and convergence monitoring
- **Transformer evaluation** of pre-trained BERT on a commonsense reasoning benchmark
- **Zero-shot scoring** methodology for multiple-choice NLU tasks
- **Result analysis** with confusion matrices, score distributions, and error inspection

## Repository Structure

```
llm-evaluations/
├── notebooks/
│   ├── neural_network_from_scratch.ipynb   # PyTorch NN — SWAG technical interview
│   ├── transformer_evaluation.ipynb         # BERT zero-shot on SWAG commonsense reasoning
│   └── swag/
│       └── val.csv                          # SWAG validation set (17 992 examples)
├── .github/
│   └── workflows/
│       └── ci-cd.yml                        # GitHub Actions CI/CD pipeline
├── Dockerfile                               # Multi-stage production build
├── docker-compose.staging.yml               # Staging environment
├── pyproject.toml                           # Project metadata & tool configs
├── requirements.txt                         # Production dependencies
└── requirements-dev.txt                     # Development dependencies
```

## Notebooks

### 1 — Neural Network from Scratch with PyTorch

**`notebooks/neural_network_from_scratch.ipynb`**

Builds a handcrafted two-pathway neural network with PyTorch to solve a dose-effectiveness regression problem:

- **Architecture**: Two-pathway network with fixed weights, ReLU activations, and a single trainable output bias (`bfinal`)
- **Task**: Learn the non-linear mapping `{dose=0 → 0, dose=0.5 → 1, dose=1 → 0}`
- **Training**: 200 epochs with SGD (lr=0.01), MSE loss, early stopping at loss < 0.01
- **Visualization**: Seaborn line plots comparing predictions before and after training

---

### 2 — Transformer Evaluation on SWAG (Commonsense Reasoning)

**`notebooks/transformer_evaluation.ipynb`**

Evaluates `bert-base-uncased` in a **zero-shot** setting on the [SWAG dataset](https://rowanzellers.com/swag/), a grounded commonsense inference benchmark derived from video captions.

#### Task format

Given a premise sentence and four candidate continuations, the model must pick the most plausible one:

```
Premise  : "She opened the door and..."
Choice A : "...sat down on the couch."   ← gold label
Choice B : "...flew to the moon."
Choice C : "...turned into a cat."
Choice D : "...disappeared into thin air."
```

#### Methodology

| Step | Details |
|------|---------|
| **Scoring** | Zero-shot: concatenate `(premise, ending)` → BERT → logit[1] as plausibility score |
| **Prediction** | `argmax` over the four candidate scores |
| **Dataset** | SWAG `val.csv` — 17 992 examples, configurable sample size |
| **Model** | `bert-base-uncased` — 110M parameters, no fine-tuning |

#### Analyses included

- Label distribution and random baseline (25%)
- Overall accuracy vs. random baseline
- Per-label accuracy (detects positional bias)
- Score distribution: correct vs. incorrect endings (KDE plot)
- 4×4 confusion matrix
- Top-5 most confident errors with premise and endings displayed

---

## Setup

```bash
# Clone the repository
git clone https://github.com/edwardgiamphy/llm-evaluations.git
cd llm-evaluations

# Create virtual environment
python -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# For development (linting, testing, Jupyter)
pip install -r requirements-dev.txt

# Additional dependency for transformer evaluation
pip install transformers scikit-learn

# Launch Jupyter
jupyter notebook notebooks/
```

## CI/CD

The repository includes a production-grade GitHub Actions pipeline:

| Stage | Description |
|-------|-------------|
| Lint & Format | Ruff (linting + formatting), Mypy |
| Tests | Pytest with coverage (Python 3.11 & 3.12 matrix) |
| Security | pip-audit, Bandit, Trivy |
| Docker Build | Multi-platform image (amd64 + arm64) → GHCR |
| Staging Deploy | Automated on `main` branch |
| Production Deploy | Manual approval on `v*.*.*` tags |

## Tech Stack

- **Python** 3.11 / 3.12
- **PyTorch** — Neural network framework
- **Hugging Face Transformers** — Pre-trained transformer models
- **Pandas / NumPy** — Data handling
- **Seaborn / Matplotlib** — Visualization
- **scikit-learn** — Evaluation metrics
- **Ruff** — Linting & formatting (replaces Black + isort)
- **Pytest** — Testing
- **Docker** — Containerization
- **GitHub Actions** — CI/CD

## License

MIT
