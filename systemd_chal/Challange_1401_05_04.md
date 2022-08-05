# Create a systemd Service 

## This is the script (in python)
> checking internet connectivity 
```python
import socket
import datetime
import time

"""
This functions checks connection to Google DNS server
If DNS server is reachable on port 53, then it means that
the internet is up and running
"""

# Initial Markers for Connectivity or not
check = "\N{Heavy Check Mark}"
fail = "\N{Heavy Multiplication X}"


def internet_connected(host="www.google.com", port=80):
    """
        Host: "www.google.com"
        OpenPort: 80/tcp
        Service: domain (DNS/TCP)
        """
    try:

        socket.setdefaulttimeout(5)
        socket.socket(socket.AF_INET, socket.SOCK_STREAM).connect((host, port))
        return True

    except Exception as ex:
        print(f"Something went wrong due to :\n{ex}")

    return False


try:
    # Store value of last state in this variable
    counter = 0
    while True:
        now = datetime.datetime.now()
        print(now.strftime("[%y %B %d  %H:%M:%S]"))

        if internet_connected():
            counter += 5
            print(f"Internet is up {check}\n{round(counter / 60, 2)} min \n{round(counter / 3600, 2)} hour\n")

        else:
            print(f"Internet is down ... {fail}")
        time.sleep(5)

except KeyboardInterrupt:
    print("Exiting... Bye!")


```
</br>

## This is the systemd script 
> Explanation :
1. For python program you have to set `Environment=PYTHONUNBUFFERED=1`
2. in newer versions of systemd (version +240) you have to set these two `StandardOutput=file:` And `StandardError`

```text
[Unit]
Description=Internet Connectivity Service

[Service]

Type=simple
Environment=PYTHONUNBUFFERED=1
StandardOutput=file:/tmp/connectivity.log
StandardError=inherit
ExecStart=/bin/bash -c 'exec /usr/bin/python /home/robot/Projects/Yara/Connectivity.py'
Restart=on-failure
User=root
WorkingDirectory=/home/robot/Projects/Yara
RuntimeDirectoryMode=0755

[Install]

WantedBy=multi-user.target



```

## Here is the log 
> that has written in file by systemd running
```text
[22 July 26  20:49:55]
Internet is up ✔
0.08 min 
0.0 hour

[22 July 26  20:50:00]
Internet is up ✔
0.17 min 
0.0 hour

[22 July 26  20:50:05]
Internet is up ✔
0.25 min 
0.0 hour

[22 July 26  20:50:10]
Internet is up ✔
0.33 min 
0.01 hour

[22 July 26  20:50:15]
Internet is up ✔
0.42 min 
0.01 hour

[22 July 26  20:50:20]
Internet is up ✔
0.5 min 
0.01 hour

[22 July 26  20:50:25]
Internet is up ✔
0.58 min 
0.01 hour

[22 July 26  20:50:31]
Internet is up ✔
0.67 min 
0.01 hour

[22 July 26  20:50:36]
Internet is up ✔
0.75 min 
0.01 hour

[22 July 26  20:50:41]
Internet is up ✔
0.83 min 
0.01 hour

[22 July 26  20:50:46]
Internet is up ✔
0.92 min 
0.02 hour

[22 July 26  20:50:51]
Internet is up ✔
1.0 min 
0.02 hour

[22 July 26  20:50:56]
Internet is up ✔
1.08 min 
0.02 hour

[22 July 26  20:51:01]
Internet is up ✔
1.17 min 
0.02 hour

[22 July 26  20:51:06]
Internet is up ✔
1.25 min 
0.02 hour

[22 July 26  20:51:11]
Internet is up ✔
1.33 min 
0.02 hour

[22 July 26  20:51:16]
Internet is up ✔
1.42 min 
0.02 hour

[22 July 26  20:51:21]
Internet is up ✔
1.5 min 
0.03 hour

[22 July 26  20:51:26]
Internet is up ✔
1.58 min 
0.03 hour

```
## systemd is running

![systemd is running](/home/robot/Pictures/Screenshots/systemd_running.png)