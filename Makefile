IMAGE_NAME = test_hadoop
HADOOP_URL = https://downloads.apache.org/hadoop/common/hadoop-2.10.0/hadoop-2.10.0.tar.gz
SSH_CONFIG = ./ssh/ssh_config
SSH_KEYS = ./ssh/keys

.PHONY: all
all: clean download_hadoop unpackage_hadoop docker

.PHONY: clean
clean: 
	@rm -rf hadoop-*

.PHONY: download_hadoop
download_hadoop:
	@bash ./download_hadoop.sh ${HADOOP_URL} 

.PHONY: unpackage_hadoop
unpackage_hadoop:
	@tar xzf hadoop-*.tar.gz

.PHONY: gen_ssh_keys
gen_ssh_keys:
	@ssh-keygen -t rsa -C "hadoop" -f ${SSH_KEYS}/hadoop_key -N ''

.PHONY: docker
docker:
	@docker build -t ${IMAGE_NAME} --build-arg SSH_CONFIG=${SSH_CONFIG} .


