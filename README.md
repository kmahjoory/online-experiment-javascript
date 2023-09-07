

## JavaScript Implementation of an Online Experiment Investigating Entrainment to Frequency-Modulated Sounds 🎧

This experiment is developed using **JavaScript** and **Python (Flask)**, and runs on an **NGINX** server. You can access the live experiment via the following link: [Online Experiment Link](https://www.mahjoory.com/online-experiment/)


> **Note:** The experiment is optimized for desktop PCs and requires a keyboard. It may not function as expected on mobile devices or tablets.

We provide the software and guidelines to install it on a local server or deploy it on an online server.

### Contents

- [Download](#download)
- [Installation](#installation)
- [Running on a Local Server](#running-on-a-local-server)
- [Setting Up and Running on an Online Server](#setting-up-and-running-on-an-online-server)





## Download

Clone the repository from GitHub using the following commands in your terminal. After downloading, navigate to the project folder:

```bash
git clone https://github.com/kmahjoory/online-experiment-javascript.git

# Here we assume <ProjectDirectory> is online-experiment-javascript/
cd online-experiment-javascript
```

#### Audio and Animation Files

Download the audio and animation files from the following link and copy them to the folder `<ProjectDirectory>/static/files/`:

**Link to audio and animation files:** [Download Link](https://drive.google.com/drive/folders/1HxazoqXmZ-aLlPJyfLuh1Blo4rH9uY41?usp=share_link)

Your project directory should be organized as follows:

```plaintext
<ProjectDirectory>/
│
├── app.py 
├── requirements.txt
├── Dockerfile
├── .dockerignore
├── README.md
│
├── templates/                  
│   ├── online_experiment.html              
│   ├── training.html
│   ├── ...
│ 
├── static/                  
│   ├── css/              
│   ├── js/
│   ├── images/
│   ├── files/
│       ├── audiofile1.mp3
│       ├── audiofile2.mp3
│       ├── audiofile3.mp3
│       ├── ...
```



## Installation

We use **Docker** to containerize our Flask app for deployment. Ensure that Docker is installed on your system.

#### Check for Docker Installation

```bash
docker --version
```

If Docker is not installed, follow the instructions on the [Docker website](https://docs.docker.com/engine/install/) to install it for your operating system.

#### Dockerfile Configuration

Our `Dockerfile` handles all installations and dependencies. Below is the configuration with comments for clarity:

```dockerfile
# Use the latest lightweight version of Python
FROM python:3.12-slim

# Set the working directory inside the container
WORKDIR /online-experiment-javascript

# Copy the requirements file to leverage Docker cache
COPY requirements.txt .

# Upgrade pip to the specified version
RUN pip install --upgrade pip==24.2

# Install system dependencies (if any are required, specify them here)
RUN apt-get update && apt-get install -y --no-install-recommends \
    # e.g., libsndfile1 for audio processing

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code into the container
COPY . .

# Expose port 5000 for the Flask app
EXPOSE 5000

# Set environment variable for Flask
ENV FLASK_APP=app.py

# Run the Flask application
CMD ["flask", "run", "--host=0.0.0.0"]
```

#### Building the Docker Image

Build the Docker image using the `Dockerfile`:

```bash
# Navigate to the project directory
cd <ProjectDirectory>

# Build the Docker image with a tag
docker build -t online-experiment-javascript .
```

#### Running the Docker Container

Run the Docker container, mapping your local port 5000 to the container's port 5000:

```bash
docker run -p 5000:5000 online-experiment-javascript
```

#### Verifying the Docker Container

Check if the Docker container is running:

```bash
docker ps
```

You should see `online-experiment-javascript` listed among the running containers.


## Running on a Local Server

Open your web browser and navigate to:

```
http://localhost:5000
```

The online experiment should now be accessible.

> **Note:** Running the experiment via Docker ensures a consistent environment. Alternatively, you can run the Flask app directly if you have Python and all dependencies installed.



## Setting Up and Running on an Online Server

To deploy the experiment on an online server, follow these steps:

#### Hosting Provider
 hosting service (e.g. DigitalOcean, AWS, GCP, Microsoft Azure, or Heroku) that supports Docker containers. Create a virtual machine instance. 
I have used a local machine and set up the server on Raspberry Pi. 

#### Install Docker on the Server

SSH into your server and install Docker:

```bash
sudo apt-get update
sudo apt-get install -y docker.io
```

#### Clone the Repository on the Server Machine

```bash
git clone https://github.com/kmahjoory/online-experiment-javascript.git

cd online-experiment-javascript
```

#### Build and Run the Docker Container on the Server

```bash
docker build -t online-experiment-javascript .
```

Run the Docker Container and Map the container's port 5000 to the server's port 80 (default HTTP port):

```bash
docker run -d -p 80:5000 online-experiment-javascript
```

> **Note:** The `-d` flag runs the container in detached mode.

### Set Up NGINX as a Reverse Proxy 

Install NGINX

```bash
sudo apt-get install -y nginx
```
Configure NGINX: Edit the NGINX default site configuration:

```bash
sudo nano /etc/nginx/sites-available/default
```

Add the following server block:

```nginx
server {
    listen 80;
    server_name your_domain_or_IP;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Restart NGINX

```bash
sudo systemctl restart nginx
```

Open your web browser and navigate to:

```
http://your_domain_or_IP
```

The online experiment should now be accessible.






