# LLM Evaluations

Evaluation experiments for ML and LLM models, including hands-on PyTorch implementations from technical interviews.

## Overview

This repository contains practical machine learning work demonstrating:

- **Neural network construction from scratch** using PyTorch (`nn.Module`, `nn.Parameter`)
- **Training loops** with SGD, loss computation, and convergence monitoring
- **Model evaluation** through prediction visualization (pre/post training)
- **Regression tasks** on synthetic dose-effectiveness data

## Repository Structure

```
llm-evaluations/
├── notebooks/
│   └── swag_interview.ipynb      # PyTorch NN — SWAG technical interview
├── .github/
│   └── workflows/
│       └── ci-cd.yml             # GitHub Actions CI/CD pipeline
├── Dockerfile                    # Multi-stage production build
├── docker-compose.staging.yml    # Staging environment
├── pyproject.toml                # Project metadata & tool configs
├── requirements.txt              # Production dependencies
└── requirements-dev.txt          # Development dependencies
```

## Notebooks

### SWAG Technical Interview — Neural Network from Scratch

**`notebooks/swag_interview.ipynb`**

Builds a handcrafted neural network with PyTorch to solve a dose-effectiveness regression problem:

- **Architecture**: Two-pathway network with fixed weights, ReLU activations, and a single trainable output bias
- **Task**: Learn the mapping `{dose=0 → 0, dose=0.5 → 1, dose=1 → 0}` (non-linear relationship)
- **Training**: 200 epochs with SGD (lr=0.01), MSE loss, early stopping at loss < 0.01
- **Visualization**: Seaborn plots comparing predictions before and after training

## Setup

```bash
# Clone the repository
git clone https://github.com/<your-username>/llm-evaluations.git
cd llm-evaluations

# Create virtual environment
python -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# For development (linting, testing, jupyter)
pip install -r requirements-dev.txt

# Launch Jupyter
jupyter notebook notebooks/
```

## CI/CD

The repository includes a production-grade GitHub Actions pipeline:

| Stage | Description |
|-------|-------------|
| Lint & Format | Black, Ruff, Mypy |
| Tests | Pytest with coverage (Python 3.11 & 3.12 matrix) |
| Security | pip-audit, Bandit, Trivy |
| Docker Build | Multi-platform image (amd64 + arm64) → GHCR |
| Staging Deploy | Automated on `main` branch |
| Production Deploy | Manual approval on `v*.*.*` tags |

## Tech Stack

- **Python** 3.11 / 3.12
- **PyTorch** — Neural network framework
- **Seaborn / Matplotlib** — Visualization
- **Ruff + Black** — Linting & formatting
- **Pytest** — Testing
- **Docker** — Containerization
- **GitHub Actions** — CI/CD

## License

MIT
