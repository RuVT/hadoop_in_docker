FROM centos
ARG HADOOP_USER=hadoop
ARG HADOOP_HOME=/usr/local/hadoop
ARG HADOOP_FILES=hadoop-2.10.0
RUN useradd -m ${HADOOP_USER}
COPY ${HADOOP_FILES} ${HADOOP_HOME}
RUN yum update -y
RUN yum install -y java-1.8.0-openjdk.x86_64 which
RUN echo "export JAVA_HOME=/usr" >> /home/${HADOOP_USER}/.bashrc
RUN echo "export HADOOP_HOME=${HADOOP_HOME}" >> /home/${HADOOP_USER}/.bashrc
RUN echo "export HADOOP_LIBEXEC_DIR=${HADOOP_HOME}/libexec" >> /home/${HADOOP_USER}/.bashrc
RUN echo "export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin" >> /home/${HADOOP_USER}/.bashrc
#CMD ['/bin/bash']
