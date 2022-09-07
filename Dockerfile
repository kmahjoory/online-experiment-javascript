# Use official Python 3.12-slim image from Docker Hub
FROM python:3.12-slim

# Set the working directory
WORKDIR /online-experiment-javascript

# Copy only the requirements file first to leverage Docker cache
COPY requirements.txt .

# Upgrade pip to the specified version (24.2)
RUN pip install --upgrade pip==24.2

# Install system dependencies required by some packages in requirements.txt
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libffi-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    zlib1g-dev \
    libsm6 \
    libxext6 \
    libxrender-dev \
    libgl1-mesa-glx \
    libglib2.0-0 \
    tesseract-ocr \
    poppler-utils \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Expose port 5000 to the world outside this container
EXPOSE 5000

# Define environment variable
ENV FLASK_APP=app.py

# Run the application
CMD ["flask", "run", "--host=0.0.0.0"]
#CMD ["python", "app.py"]