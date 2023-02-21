import os

dir=input(str("введите директорию для поиска:"))
bash_command = [("cd" " "+ dir), "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
path = os.getcwd()
for result in result_os.split('\n'):
    if result.find('modified') != -1:
        prepare_result = result.replace('\tmodified:   ', '')
        print(path + prepare_result)


