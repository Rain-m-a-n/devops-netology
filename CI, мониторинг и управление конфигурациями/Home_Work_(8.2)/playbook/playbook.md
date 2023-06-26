Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
## Плейбук site.yml используюется для установки на хосты ClickHouse и Vector.

1. Плейбук состоит из PLAY:
    * **Clickhouse**
        * 1 Headler  
        * 4 tasks  
    * **Vector**
      * 1 Headers
      * 1 tasks 

2. ### **Play Clickhouse**
2. Скачиваются пакеты для установки выбранной версии
    * версия ПО задается в переменной `{{clickhouse_version}}` в файле `./playbook/group_vars/clickhouse/vars.yml`
    * состав пакетов указан в значении `with_items: "{{ clickhouse_packages }}"` и подставляется зачение через `{{item}}` в цикле
      ```bash
      ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm"
            dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
      with_items: "{{ clickhouse_packages }}"
      ```
      
3. Пакеты сохраняются для последующей установки в домашней папке пользователя. 
4. Производится установка пакетов
5. По завершении установки пакетов происходит перезапуск службы `clickhouse-server`
6. Создается база данных `logs`
7. ### **Play Vector**
8. Скачивается установочный пакет необходимой версии Vector
    * версия ПО задается в переменной `./playbook/group_vars/vector/vars.yml`
9. Проверяется его наличие в системе, если отсутствует, то пакет устанавливается
10. Перезапускается служба `Vector`


   

