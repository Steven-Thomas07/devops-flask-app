# Step 1: Base image
FROM python:3.10-slim

# Step 2: Working directory
WORKDIR /app

# Step 3: Copy files
COPY ./app /app

# Step 4: Install dependencies
RUN pip install -r requirements.txt

# Step 5: Run app
CMD ["python", "app.py"]
