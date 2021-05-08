FROM gcr.io/spark-operator/spark:v2.4.5
ADD https://repo.maven.apache.org/maven2/com/aliyun/emr/emr-core/1.4.4/emr-core-1.4.4.jar ../jars/
ADD https://repo.maven.apache.org/maven2/com/aliyun/oss/aliyun-sdk-oss/3.0.0/aliyun-sdk-oss-3.0.0.jar ../jars/
ADD https://repo.maven.apache.org/maven2/org/jdom/jdom/1.1/jdom-1.1.jar ../jars/
ADD https://repo.maven.apache.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/aws-java-sdk-1.7.4.jar ../jars/
ADD https://repo.maven.apache.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/hadoop-aws-2.7.3.jar ../jars/
ADD https://repo.maven.apache.org/maven2/net/java/dev/jets3t/jets3t/0.9.0/jets3t-0.9.0.jar ../jars/
# Setup for the Prometheus JMX exporter.
RUN mkdir /prometheus
ADD https://repo.maven.apache.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.14.0/jmx_prometheus_javaagent-0.14.0.jar /prometheus/
