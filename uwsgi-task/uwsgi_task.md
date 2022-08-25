# Deploy Django with Nginx and Uwsgi

``` 
< Web-browser > <--> < Nginx Web-server > <--> < unix socket > <--> < uwsgi > <--> < Django >
```

## Steps : 
1. At first i need to create a user who has nginx user's permissions </br></br>
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
    7. `django-admin start project config` --> at first make a dir named config cuz i need have main settings and config be in a config name dir (its for being clarity)
    8. `mv config gholam` # here a picture of tree
    9. `echo "gholam.com  192.168.4.108" >> /etc/hosts` with root to set a local domain name
    10. for checking is every thing okay far now ,i need to add the server ip and gholam.com to `gholam/config/settings.py` in `ALLOWED-HOSTS = ['192.168.4.108','gholam.com','www.gholam.com']`
    11. add static files to project `STATIC_ROOT = Path.joinpath(BASE_DIR,'static/')` 
        > _Note_ : **pathlib** is better than **os** module in python ;)

## Nginx Config
1. At first you need an nginx config in `/etc/nginx/sites-available/gholam.conf ` </br></br>

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
2. Copy the `/etc/nginx/uwsgi-params` to `/var/www/nginx/gholam-project/gholam`
</br>

3. Symlink nginx conf of project : </br>
`ln -s /etc/nginx/sites-available/gholam.conf /etc/nginx/sites-enabled/gholam.conf`
</br>

4. Restart the Nginx service: </br>
`systemctl restart nginx.service`
</br>
5. Now you can see the django main page via : </br>
`uwsgi --socket config.sock --module config.wsgi` 

    (far now invoke this in your project dir)

## uWSGI ini for automating the deploy process
> The ini or conf file id for using that in vassale with emperor or using the other command </br>
first this file should be in gholam/config/gholam_uwsgi.ini
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
   * `mkdir /var/www/nginx/gholam-project/venv/vasslas `</br>
   * `ln -s /var/www/nginx/gholam-project/gholam/config/gholam_uwsgi.ini   /var/www/nginx/gholam-project/.venv/vasslas` </br>

## Here systemd
> To control all project we should set a systemd config file with uwsgi and emperor 

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

## Now you can see the main django page in your Web-Browser : 

### **`gholam.com:80/`** or just **`gholam.com`**