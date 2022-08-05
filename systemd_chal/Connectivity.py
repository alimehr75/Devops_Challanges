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


def internet_connected(host="8.8.8.8", port=53):
    """
        Host: "8.8.8.8"
        OpenPort: 53/tcp
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
