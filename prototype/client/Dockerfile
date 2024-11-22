#Ubuntu 24.04 as the base image
FROM ubuntu:24.04

#Update and Install PostgreSQL client
RUN apt-get update && apt-get install -y postgresql-client && rm -fr /var/lib/apt/lists/*

#Set the working directory
WORKDIR /app

#COPY your client application files into the container 
#COPY ap.py /app/

#Stay up
CMD ["tail","-f","/dev/null"]

