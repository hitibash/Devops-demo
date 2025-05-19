FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

RUN chmod +x run_tests.sh

ENV PYTHONPATH=/app

EXPOSE 5000

CMD ["python", "run.py"]
