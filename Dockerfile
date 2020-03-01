FROM centos
ARG HADOOP_USER=hadoop
ARG HADOOP_HOME=/usr/local/hadoop
ARG HADOOP_FILES=hadoop-2.10.0
ARG HADOOP_CONFIG_FILES=config
ARG SOURCE_FILES=src
ARG SSH_CONFIG=ssh/ssh_config
ARG SSH_KEYS=ssh/keys
RUN useradd -m ${HADOOP_USER}
COPY ${HADOOP_FILES} ${HADOOP_HOME}
COPY ${HADOOP_CONFIG_FILES} ${HADOOP_HOME}/etc/hadoop
COPY ${SOURCE_FILES}/entrypoint.sh /usr/local/bin/
COPY ${SSH_CONFIG}/ /etc/ssh/
COPY ${SSH_KEYS} /home/${HADOOP_USER}/.ssh
COPY ${SSH_KEYS}/*.pub /home/${HADOOP_USER}/.ssh/authorized_keys
RUN yum update -y
RUN yum install -y java-1.8.0-openjdk.x86_64 which
RUN yum install -y openssh-server openssh-clients
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN rm -rf /run/nologin
RUN echo "export JAVA_HOME=/usr" >> /home/${HADOOP_USER}/.bashrc
RUN echo "export HADOOP_HOME=${HADOOP_HOME}" >> /home/${HADOOP_USER}/.bashrc
RUN echo "export HADOOP_LIBEXEC_DIR=${HADOOP_HOME}/libexec" >> /home/${HADOOP_USER}/.bashrc
RUN echo "export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin" >> /home/${HADOOP_USER}/.bashrc
#ENTRYPOINT [] 
CMD ['/bin/bash', '/usr/local/bin/entrypoint.sh']
