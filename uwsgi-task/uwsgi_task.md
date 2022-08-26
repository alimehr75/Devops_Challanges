# Deploy Django with Nginx and uWSGI

``` 
< Web-browser > <--> < Nginx Web-server > <--> < unix socket > <--> < uwsgi > <--> < Django >
```

## Steps : 
1. At first create a user who has nginx user's permissions </br></br>
    1. `useradd -m -d /home/wsgiapp wsgiapp`
    2. `usermod -s /bin/bash wsgiapp`
    3. `usermod -aG www-data wsgiapp`
    4. `usermod -aG wsgiapp www-data`
    5. `passwd wsgiapp`
</br></br></br>
2. Create a Directory for Project with root user in `/var/www/nginx` dir and chown it to project user.</br></br>
    1. `mkdir gholam-project`
    2. `chown wsgiapp:wsgiapp gholam-project`
    3. `python3 -m venv .venv`
    4. `source .venv/bin/activate`
    5. `pip3 install django`
    6. `pip3 install wheel uwsgi`
    7. `django-admin startproject config` --> at first creat project named config cuz i need have main settings and config files be in a config  dir (its for being clarity)
    8. `mv config gholam` 
    9. `echo "gholam.com  192.168.4.108" >> /etc/hosts` with root to set a local domain name
    10. For checking is every thing okay far now ,add the server ip and gholam.com to `gholam/config/settings.py` in `ALLOWED-HOSTS = ['192.168.4.108','gholam.com','www.gholam.com']`
    11. add static files to project `STATIC_ROOT = Path.joinpath(BASE_DIR,'static/')` 
        > _Note_ : **pathlib** is better than **os** module in python ;)

## Nginx Config
1. At first you need an nginx config in `/etc/nginx/sites-available/gholam.conf ` </br></br>

[Nginx Config file](https://github.com/alimehr75/Devops_Challanges/blob/main/uwsgi-task/gholam_nginx.conf)

```
upstream gholam-project {
        server unix:///var/www/nginx/gholam-project/gholam/config.sock;

server {

        listen               80 default_server;

        server_name          gholam.com www.gholam.com;
        root                 /var/www/nginx/gholam-project/gholam;
        index                index.html index.htm;

        charset              utf-8;
        client_max_body_size 50M;

        access_log           /var/www/nginx/gholam-project/gholam_access.log;
        error_log           /var/www/nginx/gholam-project/gholam_error.log;

        location /media {
                alias /var/www/nginx/gholam-project/gholam/media;

        }

        location /static {
                alias /var/www/nginx/gholam-project/gholam/static;

        }

        location / {
                uwsgi_pass gholam-project;
                include /var/www/nginx/gholam-project/gholam/config/uwsgi_params;

        }


}
```
1. Copy the `/etc/nginx/uwsgi-params` to `/var/www/nginx/gholam-project/gholam/config`
</br>

3. For collect the static params :</br>
   `python manage.py collectstatis `

4. Symlink nginx conf  : </br>
`ln -s /etc/nginx/sites-available/gholam.conf /etc/nginx/sites-enabled/gholam.conf`
</br>

5. Restart the Nginx service: </br>
   `systemctl restart nginx.service`
</br>
6. Now you can see the django main page via : </br>
`uwsgi --socket config.sock --module config.wsgi` 

    **Note**: far now invoke this in your project dir

## uWSGI ini for automating the deploy process
> The ini or conf file is for using it in vassale with emperor or using `uwsgi --ini config-file.ini` </br>
first this file should be in gholam/config/gholam_uwsgi.ini

[uWSGI Config File](https://github.com/alimehr75/Devops_Challanges/blob/main/uwsgi-task/gholam_uwsgi.ini)

```
[uwsgi]

# ------- Django Section ---------------

# Base Directory 
chdir        = /var/www/nginx/gholam-project/gholam
# Wsgi File
module       = config.wsgi
# Home (path for python env)
home         = /var/www/nginx/gholam-project/.venv

# ------- Process Section ---------------

# Master 
master       = True 
# Process id number
pidfile=/run/uwsgi/gholam.pid
# Harakiri, is the maximum time a single request can run
harakiri=20
# Maximum number of workers 
workers      = 3
# Socket file
socket       = /var/www/nginx/gholam-project/gholam/config.sock
# Socket permision
chmod-socket = 666
# Clean the environement
vacuum       = True 
# Logging
daemonize    = /var/www/nginx/gholam-project/log/uwsgi-emperor.log
```
1. now we can run the project via : </br>
`uwsgi --ini gholam_uwsgi.ini` in config dir</br>
2. link this ini file into python venv in a dir named vassals to govern the uwsgi with Emperor </br>
   * `mkdir /var/www/nginx/gholam-project/.venv/vasslas `</br>
   * `ln -s /var/www/nginx/gholam-project/gholam/config/gholam_uwsgi.ini   /var/www/nginx/gholam-project/.venv/vasslas` </br>

## Systemd Service Config
> To control all project with systemctl that just deals with Emperor
[Systemd Config File](https://github.com/alimehr75/Devops_Challanges/blob/main/uwsgi-task/emperor.uwsgi.service)

```
[Unit]
Description=uWSGI Emperor 
After=network.target

[Service]
User=wsgiapp
RuntimeDirectory=uwsgi
ExecStart=/var/www/nginx/gholam-project/.venv/bin/uwsgi --emperor /var/www/nginx/gholam-project/.venv/vassals --uid www-data --gid www-data 
Restart=always
RestartSec=5s
KillSignal=SIGQUIT

[Install]
WantedBy=multi-user.target

```
start the created service:</br>
`systemctl start emperor.uwsgi.service`



## Now you can see the main django page in your Web-Browser : 

### **`gholam.com:80/`** or just **`gholam.com`**

![](https://github.com/alimehr75/Devops_Challanges/blob/main/uwsgi-task/Final.png?raw=true)


# More Features 

## SSL configs

> Here We are going to add `ssl` in Nginx with openssl
1. `mkdir /etc/nginx/ssl && cd /etc/nginx/ssl`
2. `sudo openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:4096 -keyout private.key -out certificate.crt`
> now its time to add ssl  and ipv6 config to project's nginx config file.
3. [Here you can see the changes in nginx config file](https://github.com/alimehr75/Devops_Challanges/blob/main/uwsgi-task/gholam_nginx.conf)
4. `systemctl restart nginx`
5. `systemctl restart emperor.uwsgi.service`</br></br></br>
![Https1](https://github.com/alimehr75/Devops_Challanges/blob/main/uwsgi-task/Https1.png?raw=true)
-----
</br></br></br>
![Https2](https://github.com/alimehr75/Devops_Challanges/blob/main/uwsgi-task/HTTPS2.png?raw=true)

</br></br></br>

## Django App Configs

> here we are going to add a django app and create superuser to be able to login to app's admin page.
1. `cd /var/www/nginx/gholam-project/gholam`
2. `source /var/www/nginx/gholam-project/.venv/bin/activate`
3. `python3 manage.py createapp Yara`
4. `python3 manage.py createsuperuser`</br></br></br>
![Super user](https://github.com/alimehr75/Devops_Challanges/blob/main/uwsgi-task/SuperUser.png?raw=true)
</br></br></br>
---

> Here is the login page of admin --> gholam.com/admin 

![login to admin page](https://github.com/alimehr75/Devops_Challanges/blob/main/uwsgi-task/Loginpage.png?raw=true)


> This is the Admin page that we've just created 

![Admin Page after login](https://github.com/alimehr75/Devops_Challanges/blob/main/uwsgi-task/Admin_pannel.png?raw=true)

> And Here You can see the users section the and `wsgiapp` user that we've just created it ;)

![Users](https://github.com/alimehr75/Devops_Challanges/blob/main/uwsgi-task/Users.png?raw=true)


## Yara App 

> Read the document of Django how make an app  [Here](https://docs.djangoproject.com/en/4.1/intro/tutorial01/)

![Question1](https://github.com/alimehr75/Devops_Challanges/blob/main/uwsgi-task/Question1.png?raw=true)
</br></br></br>

---

</br></br></br>

![Question2](https://github.com/alimehr75/Devops_Challanges/blob/main/uwsgi-task/Question2.png?raw=true)


> And the main page when you type `gholam.com` in a Web-Browser

![Home page](https://github.com/alimehr75/Devops_Challanges/blob/main/uwsgi-task/Home_html.png?raw=true)




