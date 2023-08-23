# Домашнее задание к занятию 16 «Платформа мониторинга Sentry»

## Задание 1

Так как Self-Hosted Sentry довольно требовательная к ресурсам система, мы будем использовать Free Сloud account.

Free Cloud account имеет ограничения:

- 5 000 errors;
- 10 000 transactions;
- 1 GB attachments.

Для подключения Free Cloud account:

- зайдите на sentry.io;
- нажмите «Try for free»;
- используйте авторизацию через ваш GitHub-аккаунт;
- далее следуйте инструкциям.

В качестве решения задания пришлите скриншот меню Projects.  
    ![res](https://github.com/Rain-m-a-n/devops-netology/blob/master/%D0%A1%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20%D0%BC%D0%BE%D0%BD%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%BD%D0%B3%D0%B0/Home_Work_(10.5)/pics/project.png)
## Задание 2

1. Создайте python-проект и нажмите `Generate sample event` для генерации тестового события.  
   ![res](https://github.com/Rain-m-a-n/devops-netology/blob/master/%D0%A1%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20%D0%BC%D0%BE%D0%BD%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%BD%D0%B3%D0%B0/Home_Work_(10.5)/pics/issues.png)
1. Изучите информацию, представленную в событии.  
   ![res](https://github.com/Rain-m-a-n/devops-netology/blob/master/%D0%A1%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20%D0%BC%D0%BE%D0%BD%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%BD%D0%B3%D0%B0/Home_Work_(10.5)/pics/issues1.png)
1. Перейдите в список событий проекта, выберите созданное вами и нажмите `Resolved`.
1. В качестве решения задание предоставьте скриншот `Stack trace` из этого события и список событий проекта после нажатия `Resolved`.  
   ![res](https://github.com/Rain-m-a-n/devops-netology/blob/master/%D0%A1%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20%D0%BC%D0%BE%D0%BD%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%BD%D0%B3%D0%B0/Home_Work_(10.5)/pics/project1.png)   
    Resolved  
   ![res](https://github.com/Rain-m-a-n/devops-netology/blob/master/%D0%A1%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20%D0%BC%D0%BE%D0%BD%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%BD%D0%B3%D0%B0/Home_Work_(10.5)/pics/issues3.png)
## Задание 3

1. Перейдите в создание правил алёртинга.
2. Выберите проект и создайте дефолтное правило алёртинга без настройки полей.
3. Снова сгенерируйте событие `Generate sample event`.
Если всё было выполнено правильно — через некоторое время вам на почту, привязанную к GitHub-аккаунту, придёт оповещение о произошедшем событии.
4. Если сообщение не пришло — проверьте настройки аккаунта Sentry (например, привязанную почту), что у вас не было 
`sample issue` до того, как вы его сгенерировали, и то, что правило алёртинга выставлено по дефолту (во всех полях all).
Также проверьте проект, в котором вы создаёте событие — возможно алёрт привязан к другому.
5. В качестве решения задания пришлите скриншот тела сообщения из оповещения на почте.  
   ![res](https://github.com/Rain-m-a-n/devops-netology/blob/master/%D0%A1%D0%B8%D1%81%D1%82%D0%B5%D0%BC%D1%8B%20%D0%BC%D0%BE%D0%BD%D0%B8%D1%82%D0%BE%D1%80%D0%B8%D0%BD%D0%B3%D0%B0/Home_Work_(10.5)/pics/error.png)
6. Дополнительно поэкспериментируйте с правилами алёртинга. Выбирайте разные условия отправки и создавайте sample events.  
   
