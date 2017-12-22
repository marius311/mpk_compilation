build:
	docker build -t marius311/tegmark_zaldarriaga_figure .

pull: 
	docker pull marius311/tegmark_zaldarriaga_figure
	
PORT:=8888
start:
	docker run --rm -itp $(PORT):$(PORT) \
		-v `pwd`/shared:/home/cosmo/shared \
		marius311/tegmark_zaldarriaga_figure \
		jupyter-notebook --ip=* --no-browser --port $(PORT) \
		| (sleep 1 && sed -e "s/localhost/$$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' tegfig)/g")
