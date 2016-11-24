build:
	docker build -t tegfig .

start:
	docker run -dtp 8888 --name tegfig -v `pwd`:/root/shared tegfig
	@echo "Now point browser to $$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' tegfig):8888"

stop:
	docker rm -f tegfig
