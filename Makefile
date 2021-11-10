IMAGE_NAME = test_hadoop
DOWNLOAD_DIR = ./downloads
EXTRACT_DIR = ./extract
HADOOP_VERSION = 2.10.1
HADOOP_URL = https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz
HADOOP_FILES = ${DOWNLOAD_DIR}/hadoop-${HADOOP_VERSION}.tar.gz
SSH_CONFIG = ./ssh/ssh_config
SSH_KEYS = ./ssh/keys

.PHONY: all
all: ssh_keys download_hadoop docker

.PHONY: clean
clean: 
	@rm -rf hadoop-*

mkdir_DOWNLOAD_DIR:
	@mkdir -p ${DOWNLOAD_DIR}

.PHONY: download_hadoop
download_hadoop: mkdir_DOWNLOAD_DIR
	@bash ./download.sh ${HADOOP_URL} ${DOWNLOAD_DIR}

.PHONY: unpackage_hadoop
unpackage_hadoop:
	@mkdir -p ${EXTRACT_DIR}
	@tar -xzf ${DOWNLOAD_DIR}/hadoop-${HADOOP_VERSION}.tar.gz --directory ${EXTRACT_DIR}

.PHONY: download_test_data
download_test_data: mkdir_DOWNLOAD_DIR
	@aws s3 cp s3://hadoopbook/ncdc/all ${DOWNLOAD_DIR}/data --recursive

.PHONY: ssh_keys
ssh_keys:
	@mkdir -p ${SSH_KEYS}
	@test -f ${SSH_KEYS}/id_rsa || ssh-keygen -t rsa -C "hadoop" -f ${SSH_KEYS}/id_rsa -P '' && cp ${SSH_KEYS}/*.pub ${SSH_KEYS}/authorized_keys


.PHONY: docker
docker:
	@docker build -t ${IMAGE_NAME} \
		--build-arg SSH_CONFIG=${SSH_CONFIG} \
		--build-arg HADOOP_VERSION=${HADOOP_VERSION} \
		--build-arg HADOOP_TAR_DIR=${DOWNLOAD_DIR} .


