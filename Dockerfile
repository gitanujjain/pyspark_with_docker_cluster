
FROM python:3.11-slim-bullseye
ARG SPARK_VERSION=4.1.2

# Install required system dependencies for Spark and Hadoop
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \  
    vim \   
    unzip \     
    rsync \               
    openjdk-11-jdk \      
    build-essential \     
    software-properties-common \ 
    ssh && \            
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* 

# Set environment variables for Spark and Hadoop
ENV SPARK_HOME=${SPARK_HOME:-"/opt/spark"}
ENV HADOOP_HOME=${HADOOP_HOME:-"/opt/hadoop"}

# Create necessary directories for Spark and Hadoop
RUN mkdir -p ${HADOOP_HOME} && mkdir -p ${SPARK_HOME}
WORKDIR ${SPARK_HOME}

# Download and install Spark using the specified SPARK_VERSION
# ⚠️ Make sure that the version specified in SPARK_VERSION exists on the Apache server!
RUN curl https://dlcdn.apache.org/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop3.tgz -o spark-${SPARK_VERSION}-bin-hadoop3.tgz \
 && tar xvzf spark-${SPARK_VERSION}-bin-hadoop3.tgz --directory /opt/spark --strip-components 1 \
 && rm -rf spark-${SPARK_VERSION}-bin-hadoop3.tgz  # Remove the archive to save space

# Install required Python dependencies
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Add Spark paths to the environment variables
ENV PATH="/opt/spark/sbin:/opt/spark/bin:${PATH}"
ENV SPARK_HOME="/opt/spark"
ENV SPARK_MASTER="spark://spark-master:7077"
ENV SPARK_MASTER_HOST=spark-master
ENV SPARK_MASTER_PORT=7077
ENV PYSPARK_PYTHON=python3


# Copy Spark configuration file
COPY spark-defaults.conf ${SPARK_HOME}/conf/

# Grant execution permissions to Spark scripts
RUN chmod u+x /opt/spark/sbin/* && \
    chmod u+x /opt/spark/bin/*

# Add PySpark to PYTHONPATH to allow Spark module imports in Python
ENV PYTHONPATH=$SPARK_HOME/python/:$PYTHONPATH

# Copy the entrypoint script that will start the required services
COPY entrypoint.sh .

RUN chmod u+x entrypoint.sh
# Define the container entrypoint
CMD ["entrypoint.sh"]