DOCKER_NETWORK = hadoop.net
ENV_FILE = hadoop.env
current_branch := 1.0.0
build:
	docker build -t docker-hadoop-base:$(current_branch) ./base
	docker build -t docker-hadoop-namenode:$(current_branch) ./namenode
	docker build -t docker-hadoop-datanode:$(current_branch) ./datanode
	docker build -t docker-hadoop-resourcemanager:$(current_branch) ./resourcemanager
	docker build -t docker-hadoop-historyserver:$(current_branch) ./historyserver
	docker build -t docker-hadoop-hive:$(current_branch) ./hive
	docker build -t docker-hadoop-hue:$(current_branch) ./hue
	docker build -t docker-hadoop-trino:$(current_branch) ./trino
