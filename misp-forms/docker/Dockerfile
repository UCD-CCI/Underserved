FROM python:3.10

WORKDIR /app

COPY . /app

RUN apt-get update && apt-get install -y \
    zbar-tools \
    tesseract-ocr \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -r requirements.txt

COPY .env /app/.env

EXPOSE 5000

ENV FLASK_APP=app.py

CMD ["flask", "run", "--host=0.0.0.0"]
