FROM centos
ARG HADOOP_USER=hadoop
ARG HADOOP_HOME=/usr/local/hadoop
ARG HADOOP_VERSION=2.10.1
ARG HADOOP_DIR_NAME=hadoop-${HADOOP_VERSION}
ARG HADOOP_TAR_DIR=./downloads
ARG HADOOP_TAR_FILE_NAME=${HADOOP_DIR_NAME}.tar.gz
ARG HADOOP_CONFIG_FILES=config
ARG SOURCE_FILES=src
ARG SSH_CONFIG=ssh/ssh_config
ARG SSH_KEYS=ssh/keys
RUN useradd -m ${HADOOP_USER}
RUN yum update -y
RUN yum install -y java-1.8.0-openjdk.x86_64 which
RUN yum install -y openssh-server openssh-clients
COPY ${HADOOP_TAR_DIR}/${HADOOP_TAR_FILE_NAME} /tmp/${HADOOP_TAR_FILE_NAME}
RUN mkdir -p ${HADOOP_HOME}
RUN tar -xzf /tmp/hadoop-*.tar.gz --strip 1 --directory ${HADOOP_HOME}
RUN ls ${HADOOP_HOME}
COPY ${HADOOP_CONFIG_FILES} ${HADOOP_HOME}/etc/hadoop
COPY ${SOURCE_FILES}/ /usr/local/bin/
COPY ${SSH_CONFIG}/ /etc/ssh/
COPY ${SSH_KEYS} /home/${HADOOP_USER}/.ssh
RUN chmod 755  /usr/local/bin/*
RUN chmod 700 /home/${HADOOP_USER}/.ssh
RUN chmod 600 /home/${HADOOP_USER}/.ssh/*
RUN chown -R hadoop:hadoop ${HADOOP_HOME}
RUN chown -R hadoop:hadoop /home/${HADOOP_USER}/.ssh
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N ''
RUN rm -rf /run/nologin
RUN echo "export JAVA_HOME=/usr/lib/jvm/jre-openjdk/" >> /home/${HADOOP_USER}/.bashrc
RUN echo "export HADOOP_HOME=${HADOOP_HOME}" >> /home/${HADOOP_USER}/.bashrc
RUN echo "export HADOOP_LIBEXEC_DIR=${HADOOP_HOME}/libexec" >> /home/${HADOOP_USER}/.bashrc
RUN echo "export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin" >> /home/${HADOOP_USER}/.bashrc
CMD ["/bin/bash"]
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"] 
