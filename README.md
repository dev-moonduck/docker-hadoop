# Docker hadoop cluster
This is hadoop docker cluster for test purpose. 
It's not Psuedo-Distributed, but normal distributed hadoop cluster. If you want to build Hadoop Apps, this cluster can be good to test your app.  
Basically Frameworks on top of hadoop in this cluster is based on my company tech stack.  
This project was forked from [docker-hadoop](https://github.com/big-data-europe/docker-hadoop).

# Diagram
![Architectur](./docs/images/Architecture.png)

# Getting started
## 1. Build Spark
```bash
$> make build-spark
```
It will take times. Basically it builds spark 3.1 with Hadoop 3.3.0, Scala 2.13, yarn, hive-thrift server
The reason that builds spark is because current released spark version is built on Hadoop2.x/Scala 2.12
## 2. Build All images
```bash
$> make build-all-images
```
It will build all required images.

## 3. Run images
```bash
$> docker-compose up -d
```

Enjoy!

# **Frameworks Version**  
|  Framework      |  Version  |              |
|-----------------|-----------|--------------|
|  Hadoop         |  3.3.0    |              |
|  Hive           |  3.1.2    |              |
|  Spark          |  3.1.0    |  Scala 2.13  |
|  Hue            |  4.9.0    |              |
|  Trino(Presto)  |           |  TODO        | 
|  Airflow        |           |  TODO        |
    

# **Predefined Users**  
Users are defined in [base](./base/Dockerfile) image
|  Username  |  Password  |  is proxy?  |  Description  |
|------------|------------|-------------|--------|
|  hdfs      |  hdfs      |    -        |  Super user  |
|  webhdfs   |  webhdfs   |    Y        | Webhdfs service user |
|  hive      |  hive      |    Y        |  Hive service user  |
|  trino     |  trino     |    Y        |  Trino service user  |
|  kafka     |  kafka     |    Y        |  Kafka service user  |
|  hue       |  hue       |    Y        |  Hue service user  |
|  spark     |  spark     |    Y        |  Spark service user  |
|  svc       |  svc       |    Y        |  User's service user  |
|  ml_user   |  ml_user   |    N        |  ml team user  |
|  bi_user   |  bi_user   |    N        |  bi team user  |
|  dev_user  |  dev_user  |    N        |  dev team user  |


# How does it work?



# How to add / remove datanode?




# Limitations
- Federation is not available
- Trino(Presto) is not available yet
- Client outside container can use only WebHDFS


# TODO
- Get rid of useradd in base image, but use Ansible for adding new users
- Apache Iceberg
- Make Trino work
- ETL Tool

# Tested machine
- Macbook PRO(Catalina) 32GB DDR4 2400Mhz 8Core Intel Core i9

# Miscellaneous
- It's welcome to raise PR/Issue for this repo If you faced an issue