# SOW Section 2.1: Python 3.12
FROM python:3.12-slim

WORKDIR /app

# Install dependencies for ARM64 compatibility
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libpq-dev \
    gcc \
    && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python -m venv /app/venv
ENV PATH="/app/venv/bin:$PATH"

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose port
EXPOSE 8000

# Default command (override in docker-compose for dev)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
