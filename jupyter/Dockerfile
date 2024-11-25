#FROM tensorflow/tensorflow:2.2.0-jupyter
#ARG IMAGE=jupyter/pytorch-notebook
#SCIPY and Tensorflow
ARG IMAGE=jupyter/tensorflow-notebook
ARG IMAGE=jupyter/scipy-notebook

FROM $IMAGE
LABEL maintainer="Pierre-Yves Dquesnoy <Pierre-Yves.Duquesnoy@intersystems.com>"

USER root
RUN apt-get update && apt-get install -y default-jre-headless && apt-get clean && rm -rf /var/lib/apt/lists/*

USER jovyan
#Get the InterSystens IRIS DB-API Driver
#Not: this fails from the docker container in 
#RUN wget https://raw.githubusercontent.com/intersystems-community/iris-driver-distribution/main/DB-API/intersystems_iris-3.3.1-py3-none-any.whl 
COPY intersystems_irispython-3.2.0-py3-none-any.whl ./
RUN pip install intersystems_irispython-3.2.0-py3-none-any.whl


# install python libs
COPY requirements.txt ./ 
COPY intersystems-jdbc-3.1.0.jar ./

RUN pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

#Jupyter Port
#EXPOSE 8888

#CMD /bin/bash -c "source /etc/bash.bashrc && jupyter lab --notebook-dir=/notebooks --ip 0.0.0.0 --no-browser --allow-root --NotebookApp.token=''"
WORKDIR /notebooks

CMD ["start-notebook.sh","--NotebookApp.token=''","--notebook-dir=/notebooks"]