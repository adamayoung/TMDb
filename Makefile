linuxtest:
	docker build -f Dockerfile -t linuxtest .
	docker run linuxtest
