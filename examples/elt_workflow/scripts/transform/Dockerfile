FROM python:3.12-slim

# Set the working directory
WORKDIR /app

# Copy requirements and transformation files
COPY requirements.txt transform_data.py /app/

# Install requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Define the command to run your script
CMD ["python", "transform_data.py"]