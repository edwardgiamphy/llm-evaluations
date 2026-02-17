# ============================================================
#  Dockerfile — Python API (FastAPI / Django / Flask)
#  Multi-stage build : image finale légère (~120MB vs ~900MB)
# ============================================================

# ── Stage 1 : Builder ────────────────────────────────────────
FROM python:3.12-slim AS builder

# Évite les fichiers .pyc et active les logs non-bufférisés
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

WORKDIR /build

# Installer les dépendances système nécessaires à la compilation
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copier et installer les dépendances Python dans un venv isolé
COPY requirements.txt .
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
RUN pip install --upgrade pip && pip install -r requirements.txt

# ── Stage 2 : Runtime (image finale) ─────────────────────────
FROM python:3.12-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /app

# Installer uniquement les libs runtime (pas les outils de build)
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Créer un utilisateur non-root pour la sécurité
RUN groupadd --gid 1001 appgroup && \
    useradd --uid 1001 --gid appgroup --shell /bin/bash --create-home appuser

# Copier le venv depuis le builder
COPY --from=builder /opt/venv /opt/venv

# Copier le code source
COPY --chown=appuser:appgroup . .

# Basculer vers l'utilisateur non-root
USER appuser

EXPOSE 8000

# Health check intégré à l'image
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8000/health || exit 1

# ── Commande de démarrage ─────────────────────────────────────
# FastAPI avec Uvicorn :
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]

# Django avec Gunicorn :
# CMD ["gunicorn", "config.wsgi:application", "--bind", "0.0.0.0:8000", "--workers", "4"]

# Flask avec Gunicorn :
# CMD ["gunicorn", "app:create_app()", "--bind", "0.0.0.0:8000", "--workers", "4"]
