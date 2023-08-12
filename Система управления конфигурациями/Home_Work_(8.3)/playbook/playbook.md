Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
## Плейбук site.yml используюется для установки на хосты ClickHouse, Vector, Nginx, Lighthouse.

1. Плейбук состоит из PLAY:
    * **Clickhouse**
        * 1 headler  
        * 4 tasks  
    * **Vector**
      * 1 headers
      * 1 tasks 
    * **Lighthouse**
      * 1 headers
      * 1 pre-tasks
      * 6 tasks

### **Play Clickhouse**
1. Скачиваются пакеты для установки выбранной версии
    * версия ПО задается в переменной `{{ clickhouse_version }}` в файле `./playbook/group_vars/clickhouse/vars.yml`
    * состав пакетов указан в значении `with_items: "{{ clickhouse_packages }}"` и подставляется зачение через `{{ item }}` в цикле
      ```bash
      ansible.builtin.get_url:
            url: "https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.x86_64.rpm"
        dest: "./{{ item }}-{{ clickhouse_version }}.rpm"
      with_items: "{{ clickhouse_packages }}"
      ```
4. Пакеты сохраняются для последующей установки в домашней папке пользователя. 
5. Производится установка пакетов
6. По завершении установки пакетов происходит перезапуск службы `clickhouse-server`
7. Создается база данных `logs`
   
### **Play Vector**
1.  Скачивается установочный пакет необходимой версии Vector
    * версия ПО задается в переменной `./playbook/group_vars/vector/vars.yml`
9.  Проверяется его наличие в системе, если отсутствует, то пакет устанавливается
10. Перезапускается служба `Vector`

### **Lighthouse**
1. Pre-task - выполняет скачивание необходимых зависимостей, в нашем случае это `git`.
2. Добавляем EPEL-репозиторий
3. Устанавливаем Nginx
4. Клопируем папку Lighthouse с github. Путь к репозиторию и конечная папка объявлены в переменных по пути `/group_vars/lighthouse/cars.yml`
5. Переносим шаблон конфигурации из папки `/templates/` взамен дефолтного файла конфигурации. 
6. Перезапускаем сервис Nginx
7. Добавляем правило в `Firewall` 
   
