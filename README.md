
# Connect or Collect 

Exploring the Connect or Collect Paradigm with Intersystems IRIS as a platform for a Smart Data Fabric

## Introduction

We use following scenario, with data located in different applications, to demonstrate the "connect or collect" paradigm.

<img src="./data/notebooks/img/scenario.png>



## First Steps for Quick Setup


### Start Containers

```
docker compose build
docker compose up -d
```

### Connect to Jupyter Notebook

```
http://localhost:48888
```
And Explore the NoteBook

### Connect to the IRIS Portal

```
http://localhost:42772/csp/sys/UtilHome.csp
```

From there you can access the Interoperability portal and use the CSV wizard to create a Record Map to use in a Business Service for automatic file ingestion

