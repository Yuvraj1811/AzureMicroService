# Use the official Python image
FROM python:3.9

WORKDIR /app

# Copy application code
COPY . .

# Install system dependencies
RUN apt-get update && apt-get install -y curl gnupg2 unixodbc unixodbc-dev && rm -rf /var/lib/apt/lists/*

# Add Microsoft repo key and package list safely
RUN curl -sSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg \
 && curl -sSL https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Install Microsoft ODBC driver
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y msodbcsql17 && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000

# Start FastAPI app
CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000"]