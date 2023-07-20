Ansible Role: Vector-role
=========

Устанавливает **Vector**

Role Variables
--------------
Все переменные задаются в файле `defaults/main.yml`
| Переменная | Значение по умолчанию| Описание | 
| :-----:| :-----:|:-----:|
|`vector_ver`| 0.30.0 | Указывается желаемая версия ПО |

Support platforms:
----------------

| Name | Version |
| :----: | :-----:|
| Centos| 7,8|
| Rhel | 7,8 |


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:
```yaml
    - hosts: servers
      roles:
         - role: vector-role 
```
License
-------

MIT

Author Information
------------------

Stanislav Bortnikov @2023
