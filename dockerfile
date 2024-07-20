# Use an official Python runtime as a parent image with CUDA support
FROM nvidia/cuda:11.8.0-base-ubuntu22.04

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Set the working directory in the container
WORKDIR /home/dev/pytorch_learning

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-venv \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Create a virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Install Python packages
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir jupyter notebook pytorch torchvision torchaudio

# Copy the local directory contents into the container at /home/dev/pytorch_learning
COPY . /home/dev/pytorch_learning

# Install any additional requirements from your project
RUN if [ -f requirements.txt ]; then pip install --no-cache-dir -r requirements.txt; fi

# Set up Jupyter Notebook to recognize the Python kernel
RUN python -m ipykernel install --user --name=venv

# Command to keep the container running
CMD ["tail", "-f", "/dev/null"]