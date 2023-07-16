# Домашнее задание к занятию 7 «Жизненный цикл ПО»

## Основная часть

Необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. Задачи типа bug должны проходить жизненный цикл:

1. Open -> On reproduce.
2. On reproduce -> Open, Done reproduce.
3. Done reproduce -> On fix.
4. On fix -> On reproduce, Done fix.
5. Done fix -> On test.
6. On test -> On fix, Done.
7. Done -> Closed, Open.  
![result](https://github.com/Rain-m-a-n/devops-netology/tree/master/Непрерывная%20разработка%20и%20интеграция/Home_Work_(9.1)/pics/bug.jpg)
Остальные задачи должны проходить по упрощённому workflow:

1. Open -> On develop.
2. On develop -> Open, Done develop.
3. Done develop -> On test.
4. On test -> On develop, Done.
5. Done -> Closed, Open.  
![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/Непрерывная%20разработка%20и%20интеграция/Home_Work_(9.1)/pics/all.jpg)

**Что нужно сделать**

1. Создайте задачу с типом bug, попытайтесь провести его по всему workflow до Done. 
1. Создайте задачу с типом epic, к ней привяжите несколько задач с типом task, проведите их по всему workflow до Done. 
1. При проведении обеих задач по статусам используйте kanban. 
![result](https://github.com/Rain-m-a-n/devops-netology/blob/master/Непрерывная%20разработка%20и%20интеграция/Home_Work_(9.1)/pics/kanban.jpg)
2. Верните задачи в статус Open.
3. Перейдите в Scrum, запланируйте новый спринт, состоящий из задач эпика и одного бага, стартуйте спринт, проведите задачи до состояния Closed. Закройте спринт.
![result](https://github.com/Rain-m-a-n/devops-netology/bloob/master/Непрерывная%20разработка%20и%20интеграция/Home_Work_(9.1)/pics/sprint_end.jpg)
1. Если всё отработалось в рамках ожидания — выгрузите схемы workflow для импорта в XML. Файлы с workflow и скриншоты workflow приложите к решению задания.  
[Workflow_BUG.xml](https://github.com/Rain-m-a-n/devops-netology/blob/master/Непрерывная%20разработка%20и%20интеграция/Home_Work_(9.1)/files/netology.xml)    
[Workflow_All_other.xml](https://github.com/Rain-m-a-n/devops-netology/blob/master/Непрерывная%20разработка%20и%20интеграция/Home_Work_(9.1)/files/another.xml)    


---
