.PHONY: all
all: download_hadoop

.PHONY: download_hadoop unpackage_hadoop docker
download_hadoop:
	@wget https://downloads.apache.org/hadoop/common/hadoop-2.10.0/hadoop-2.10.0.tar.gz

.PHONY: unpackage_hadoop
unpackage_hadoop:
	@tar xzf hadoop-*.tar.gz

.PHONY: docker
docker:
	@docker build -t test_hadoop .


