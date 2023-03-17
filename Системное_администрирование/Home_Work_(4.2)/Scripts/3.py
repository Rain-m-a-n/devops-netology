import time
import socket

site = {"drive.google.com": 0, "mail.google.com": 0, "google.com": 0}

# Определяем IP и заменяем значения в словаре
# for host in site:
#     addr = socket.gethostbyname(host)
#     site[host] = addr

while True:
    print("******************************************") 
    for host in site:
        new_addr = socket.gethostbyname(host)
        old_addr = site[host] 
        if new_addr != old_addr:
            site[host] = new_addr
            print (f"[ERROR]  ", host, "IP mismatch:\t", "old_IP  ", old_addr, " > ", "new_IP  ",new_addr)
        else:
            print(host,"      \t" ,  new_addr)
    time.sleep(10)
