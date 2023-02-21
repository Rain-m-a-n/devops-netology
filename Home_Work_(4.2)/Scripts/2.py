import time
import socket

site= ["drive.google.com", "mail.google.com", "google.com"]
#Определяем IP 
d=(socket.gethostbyname_ex(site[0]))[2]
m=(socket.gethostbyname_ex(site[1]))[2]
g=(socket.gethostbyname_ex(site[2]))[2]

#Преобразуем в число
drive=str(d)[2:-2]
mail=str(m)[2:-2]
goog=str(g)[2:-2]

while True:
    print("******************************************")
    for test in site:
        new_addr=socket.gethostbyname_ex(test)[2]
        if new_addr ==d:
            print(f"drive.google.com\t" , "-", drive)
        elif new_addr == m:
            print (f"mail.google.com\t\t" , "-", mail)
        elif new_addr == g:
            print (f"google.com\t\t" , "-", goog)
        else:
            if test == site[0]:
                print (f"[ERROR]", test, "IP mismatch:", d, ">", new_addr)
            elif test == site[1]:
                print (f"[ERROR]", test, "IP mismatch:", m, ">", new_addr)
            elif test == site[2]:
                print (f"[ERROR]", test, "IP mismatch:", m, ">", new_addr)
            else:
               break
    print("******************************************\n")
    time.sleep(5)



