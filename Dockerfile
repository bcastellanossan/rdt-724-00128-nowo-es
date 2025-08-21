FROM python:3.10-slim

ARG GOOGLE_ACCESS_TOKEN
ENV GOOGLE_ACCESS_TOKEN=$GOOGLE_ACCESS_TOKEN

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PYTHONIOENCODING=UTF-8

RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    pkg-config \
    libgomp1 && \
    rm -rf /var/lib/apt/lists/*

RUN pip install poetry
RUN poetry config virtualenvs.create false

# Todo el proyecto dentro de /app
WORKDIR /app

# Copiar metadatos de proyecto primero (mejor cache)
COPY pyproject.toml poetry.lock* /app/

# Autenticación de Poetry para Artifact Registry
RUN poetry config http-basic.hocelot-pro oauth2accesstoken $GOOGLE_ACCESS_TOKEN && \
    poetry config http-basic.hocelot-dev oauth2accesstoken $GOOGLE_ACCESS_TOKEN

# Instalar dependencias
RUN poetry install --only=main --no-root

# Copiar el código de la app
COPY delivery /app/delivery
COPY resources /app/resources
COPY main.py /app/main.py

EXPOSE 8083

CMD ["python", "main.py"]
