IMAGE_NAME = test_hadoop
DOWNLOAD_FOLDER = ./downloads
HADOOP_URL = https://downloads.apache.org/hadoop/common/hadoop-2.10.0/hadoop-2.10.0.tar.gz
HADOOP_FILES = ${DOWNLOAD_FOLDER}/hadoop-2.10.0
SSH_CONFIG = ./ssh/ssh_config
SSH_KEYS = ./ssh/keys

.PHONY: all
all: clean download_hadoop unpackage_hadoop docker

.PHONY: clean
clean: 
	@rm -rf hadoop-*
	@rm ${SSH_KEYS}/*

mkdir_download_folder:
	@mkdir -p ${DOWNLOAD_FOLDER}

.PHONY: download_hadoop
download_hadoop: mkdir_download_folder
	@bash ./download.sh ${HADOOP_URL} ${DOWNLOAD_FOLDER}

.PHONY: unpackage_hadoop
unpackage_hadoop:
	@tar xzf ${DOWNLOAD_FOLDER}/hadoop-*.tar.gz --directory ${DOWNLOAD_FOLDER}

.PHONY: download_test_data
download_test_data: mkdir_download_folder
	@aws s3 cp s3://hadoopbook/ncdc/all ${DOWNLOAD_FOLDER}/data --recursive

.PHONY: ssh_keys
ssh_keys:
	@ssh-keygen -t rsa -C "hadoop" -f ${SSH_KEYS}/id_rsa -P '' 
	@cp ${SSH_KEYS}/*.pub ${SSH_KEYS}/authorized_keys


.PHONY: docker
docker:
	@docker build -t ${IMAGE_NAME} \
		--build-arg SSH_CONFIG=${SSH_CONFIG} \
		--build-arg HADOOP_FILES=${HADOOP_FILES} .


