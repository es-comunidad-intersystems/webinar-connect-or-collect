from python:3.11-slim

#set environment variables to prevent python from writing .pyc files and buffering stdout
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

#Set the wiorking directory
WORKDIR /app

#Copy requirements
COPY requirements.txt /app/

#Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

#COPY Application code
COPY app.py /app/

#EXPOSE streamlit default port
EXPOSE 8501

#Command to run the streamlit App
CMD ["streamlit","run","app.py","--server.port=8501","--server.address=0.0.0.0"]