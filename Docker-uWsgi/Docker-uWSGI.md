# build a Docker image of Django app with uWSGI and Nginx 

## At first lets say we have created a django project, app or ...
[Build a django project and serve it with uwsgi and nginx](https://github.com/alimehr75/Devops_Challanges/blob/main/uwsgi-task/uwsgi_task.md)

## Dockerfile for django project
1. ### At first we need create a `requirements.txt` file for using in Docker image 
> 1. `source vene/bin/activate`
> 2. `pip freeze > requirements.txt`
> 
```
asgiref==3.5.2
Django==4.1
sqlparse==0.4.2
uWSGI==2.0.20
```

2. ### create a config file for uwsgi named **Yara_uwsgi.ini**
> This ini file is gonna be in our docker image in /app dir so we need to write its options for the `/app` directory
```
[uwsgi]

# ------- Django Section ---------------

# Base Directory 
chdir        = /code
# Wsgi File
module       = Yara.wsgi

# ------- Process Section ---------------
enable-threads = true 
# Master 
master       = true 
# Maximum number of workers 
workers      = 3
# Socket file
socket       = /code/Yara.sock
# Socket permision
chmod-socket = 666
# Clean the environement
vacuum       = true 

```
3. ### Create a `Docerfile` for whole django project
> Here we need a base of docker hub repositories for our image `FROM` </br>
> then mkdir and change to `/app` dir with `WORKDIR` </br>
> Copy the whole project to `/app` </br>
> install requirements of project </br>
>  and run it with `CMD` to use the ini file.

```
From python:3-alpine

RUN apk add --update --no-cache --virtual .tmp gcc libc-dev linux-headers 

RUN python3 -m pip install -U pip

WORKDIR /code

COPY . /code

RUN pip install -r requirements.txt

CMD ["uwsgi","--ini","/code/Yara_uwsgi.ini"]


```
## Nginx Configs
1. ### At first we need to writ a config for nginx to serve the project
> `mkdir nginx` in root dir </br>
> `cd nginx` </br>
> `vi Yara-app.nginx.conf`
```
upstream wsgi-docker {
	  server                         unix:///code/Yara.sock;

}

server {
	  listen                         80;
		server_name                   Yara-app.com www.Yara-app.com;
		return                        301 https://$server_name$request_uri;

}

server {
	  listen                         443 ssl;
		server_name                  Yara-app.com www.Yara-app.com;

		ssl_certificate              /etc/nginx/certificates/domain.crt;
		ssl_certificate_key          /etc/nginx/certificates/domain.key;

		access_log                   /var/log/nginx/access-yara.log;
		error_log                    /var/log/nginx/error-yara.log;

		location /static {
			  alias /code/static;

		}

		location /media {
			  alias /code/media;

		}

		location / {
			  uwsgi_pass wsgi-docker;
			  include /etc/nginx/uwsgi_params;


		}

}

```
2. ### Creat a CA with openssl 
> `sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout domain.key -out domain.crt`

3. ### in nginx dir `Vi Dockerfile` 
> same as before we need a base image for docker image `FROM`</br> 
> change user to root</br>
> creat a dir for certificates that we've created befor and copy them in to the `certificates`</br>
> Copy the nginx config for django project</br>
> image need to expose ports to the main os to communicate with it</br>
> `CMD` Runs the nginx with no daemon 


```
FROM nginx:latest

USER root

RUN mkdir -p /etc/nginx/certificates
COPY ./domain.crt /etc/nginx/certificates/domain.crt
COPY ./domain.key /etc/nginx/certificates/domain.key

COPY ./Yara-app.nginx.conf ./etc/nginx/conf.d/Yara-app.nginx.conf

EXPOSE 80
EXPOSE 443
CMD ["nginx", "-g", "daemon off;"]

```

## Docker Compose file
> we need a docker compose file for handling the two docker images and communicate and depending to each other

1. in root dir `vi docker-compose.yml`
> `uwsgi_data` and `web_static` are share dir for two image django and nginx

```
version: '3.9'

services:

  uwsgi_django:
    build: ./Yara
    restart: always
    volumes:
      - uwsgi_data:/code
      - web_static:/code/static

  nginx:
    build: ./nginx
    restart: always
    volumes:
      - uwsgi_data:/code
      - web_static:/code/static/:ro
    ports:
      - "80:80"
      - "443:443"
    depends_on:
      - uwsgi_django 


volumes:
  uwsgi_data:
  web_static:
```
2. ### sudo docker compose build </br>

3. ### sudo docker compose up : </br></br>
![](https://github.com/alimehr75/Devops_Challanges/blob/main/Docker-uWsgi/Docker-compose%20up.png?raw=true)</br></br>

4. ### type `Yara-app.com` in your browser you'll see :</br></br>
![](https://github.com/alimehr75/Devops_Challanges/blob/main/Docker-uWsgi/Home-page.png?raw=true)</br></br>

5. ### type `Yara-app.com/admin` in your browser you'll see :</br></br>
![](https://github.com/alimehr75/Devops_Challanges/blob/main/Docker-uWsgi/Admin-page.png?raw=true)



