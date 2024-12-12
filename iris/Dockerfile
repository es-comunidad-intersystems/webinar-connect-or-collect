#ARG IMAGE=intersystemsdc/irishealth-community:2020.3.0.200.0-zpm
#ARG IMAGE=intersystemsdc/iris-community:2020.4.0.547.0-zpm
#ARG IMAGE=containers.intersystems.com/intersystems/iris:2021.1.0.215.0
#ARG IMAGE=intersystemsdc/irishealth-community
#ARG IMAGE=intersystemsdc/iris-community
ARG IMAGE=intersystemsdc/irishealth-community:preview
FROM $IMAGE as builder

WORKDIR /home/irisowner/dev

## install git
## USER root
##RUN apt update && apt-get -y install git
##USER ${ISC_PACKAGE_MGRUSER}

ARG TESTS=0
ARG MODULE="dc-sample"
ARG NAMESPACE="IRISAPP"

## Embedded Python environment
ENV IRISUSERNAME "_SYSTEM"
ENV IRISPASSWORD "SYS"
ENV IRISNAMESPACE $NAMESPACE
ENV PYTHON_PATH=/usr/irissys/bin/
ENV PATH "/usr/irissys/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/irisowner/bin"

COPY .iris_init /home/irisowner/.iris_init

RUN --mount=type=bind,src=.,dst=. \
    pip3 install -r requirements.txt && \
    iris start IRIS && \
	iris session IRIS < iris.script && \
    ([ $TESTS -eq 0 ] || iris session iris -U $NAMESPACE "##class(%ZPM.PackageManager).Shell(\"test $MODULE -v -only\",1,1)") && \
    iris stop IRIS quietly


FROM $IMAGE as final
ADD --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} https://github.com/grongierisc/iris-docker-multi-stage-script/releases/latest/download/copy-data.py /home/irisowner/dev/copy-data.py
#ADD https://github.com/grongierisc/iris-docker-multi-stage-script/releases/latest/download/copy-data.py /home/irisowner/dev/copy-data.py

RUN --mount=type=bind,source=/,target=/builder/root,from=builder \
    cp -f /builder/root/usr/irissys/iris.cpf /usr/irissys/iris.cpf && \
    python3 /home/irisowner/dev/copy-data.py -c /usr/irissys/iris.cpf -d /builder/root/

#PYD: Added code for Java + PostGreSql JDBC
#Switch to root to install Java and JDBC Driver for connecting to PostgreSql
USER root
ARG JAVA_VERSION=openjdk-8-jre-headless
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install $JAVA_VERSION && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set JAVA_HOME and update PATH
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
ENV PATH="$PATH:$JAVA_HOME/bin"

# Download PostgreSQL JDBC driver
RUN wget -O /usr/local/lib/postgresql.jar https://jdbc.postgresql.org/download/postgresql-42.6.0.jar

#Download and Add mariadb jdbc Driver
#RUN  wget -O /usr/local/lib/mariadb.jar https://downloads.mariadb.com/Connectors/java/connector-java-3.1.4/mariadb-java-client-3.1.4.jar  && \
#rm -rf /var/lib/apt/lists/*

# Switch back to the original user
USER ${ISC_PACKAGE_MGRUSER}