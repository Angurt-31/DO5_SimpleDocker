
###                           Simple Docker.

## Содержание DO5_SimpleDocker-1  

* [Реализованные требования к проекту](#реализованные-требования-к-проекту)  
* [Part 1: готовый докер](#Part-1-готовый-докер)  
* [Part 2: операции с контейнером](#Part-2-операции-с-контейнером)  
* [Part 3: мини веб-сервер](#Part-3-мини-веб-сервер)  
* [Part 4: свой докер](#Part-4-свой-докер)  
* [Part 5: dockle](#Part-5-dockle)  
* [Part 6: базовый Docker Compose](#Part-6-базовый-docker-compose)  
* [Некоторые полезные команды Docker](#некоторые-полезные-команды-docker)  
* [Некоторые полезные флаги Docker-команд](#некоторые-полезные-флаги-docker-команд)  
* [Некоторые полезные инструкции Dockerfile](#некоторые-полезные-инструкции-dockerfile)  
* [Материалы, прочитанные и просмотренные, во время и для выполнения задания](#материалы-прочитанные-и-просмотренные-во-время-и-для-выполнения-задания)   


## Реализованные требования к проекту


- В папку src/server, загружены исходные файлы для запуска веб-сервера из Part 3;
- В папку src загружены итоговые докерфайлы для запуска образов из Part 4 и Part 5;
- В папку src загружен *docker-compose.yml* из Part 6;



## Part 1. Готовый докер

<details>
  <summary>Установка Docker и запуск первого образа</summary>
</p>

Чтобы установить докер надо использовать следующую каманду  
              'sudo apt install docker.io'                                                                                                                 
![apt install docker.io](Screenshots/1_0.jpg)<br>Установка Doker<br>
  
Скачал образ nginx при помощи `sudo docker pull`                                                                                                                 
![docker pull](Screenshots/1_1.jpg) <br>скачиваем образ<br>

И проверил командой `sudo docker  images`                                                                                                                 
![docker images](Screenshots/1_2.jpg) <br>Проверяем наличие Docker образов<br>


Запустил докер-образ nginx через `docker run -d <IMAGE ID>`                                                                                                  
![docker images](Screenshots/1_3.jpg) <br>Запускаем Docker<br>

И проверил, что образ запустился командой `docker ps`                                                                                               
![docker ps](Screenshots/1_4.jpg)<br>проверяем надичие запущенного контейнера<br>
 
</p>
</details>



<details>
  <summary>Знакомство с docker inspect</summary>
</p>

Посмотри информацию о контейнере через  `docker inspect`
Для извлечения  информации о размере контейнера  находим объект `GraphDriver`  и в поле `UpperDir`
видим абсолютный путь к каталогу в котором Docker хранит изменения в файловой системею                                                                           
![docker ps](Screenshots/1_4_1.jpg)<br>Информация из docker inspect<br>

Чтoбы узнать размер этого католога надо использовать команду `du`                                                                                                
![1_4_1b](Screenshots/1_4_1c.jpg)<br>Размер католога<br>

При создании контейнера в Docker можно указать параметр `shm-size` для определения размера разделяемой памяти, доступной внутри контейнера.
Этот параметр может использоваться, например, для управления размером разделяемой памяти, доступной для процессов, работающих внутри контейнера. 
Этот параметр указывает на размер образа, из которого подняли контейнер. 
**Самый простой способ узнать размер контейнера в удобочитаемом  виде, это команды `docker ps -s` или `docker container ls -s`**                               
![docker ps -s  /  docker contaainer ls -s](Screenshots/1_4_1c.jpg)<br>Размер контейнера<br>

Они предоставляют список всех запущенных контейнеров вместе с информацией о их размере.   
Флаг `-s` указывает Docker на вывод добавочной информации о размерах контейнеров, включая реальные размеры используемых образов и файловых систем контейнеров.  
Первое значение отражает текущий размер файлов контейнера и их использование в файловой системе.  
Второе значение в скобках *(virtual ХХХMB)* указывает на размер образа, из которого подняли контейнер.  


 Понятие **замапленные порты** в контексте Docker относится к процессу связывания портов контейнера с портами хост-системы.   
Это позволяет внешним приложениям и пользователям общаться с приложениями внутри контейнера через указанные порты.  
Найти список замапленных портов можно в "NetworkSettings -> Ports"**.                                                                                          
![NetworkSettings](Screenshots/1_4_2.jpg)<br>Замапленные порты<br>    

Ip контейнера находим в поле `Networks`                                                                                                
![ip](Screenshots/1_4_3.jpg)<br>Ip контейнера<br>
 

Остановил докер образ через `docker stop container_id` и проверил через `docker ps`                                                                               
![docker stop  /  docker ps](Screenshots/1_5.jpg)<br>Останорвка контейнера<br>

Запустил докер контейнер с портами 80 и 443, замапленными на такие же порты на локальной машине, через команду `docker run -d -p 80:80 -p 443:443 `
  
Проверил, что в браузере по адресу *localhost:80* доступна стартовая страница **nginx**                                                                          
![docker ps](Screenshots/1_6.jpg)<br>Всё работает<br>

Проверил изменения через `curl -I http://localhost`                                                                                                
![curl -I http://localhost](Screenshots/1_7.jpg)<br>Результат от curl<br>

Перезапустил докер контейнер через `docker restart <container_id>` и проверил, что контейнер перезапустился                                                
![docker restart <container_id>](Screenshots/1_8.jpg)<br>рестартнули контейнер<br>
 
</p>
</details>



## Part 2. Операции с контейнером  

<details>
  <summary>Разбираемся с конфигурацией nginx и отобразим статус страницы.</summary>
</p>


> Команда exec в контексте Docker используется для выполнения команды внутри запущенного контейнера.  
Чтобы прочитать конфигурационный файл nginx.conf внутри Docker контейнера через команду exec, использовал `docker exec barkopen cat /etc/nginx/nginx.conf`       
![exec barkopen cat](Screenshots/2_1.jpg)<br>nginx.conf<br>

</p>
</details>    



<details>
  <summary>Выводим статус сервера на localhost:80/status</summary>
</p>


Создаём файл `nginx.conf`, скопировав содержимое оригинального файлафайла.  

Дописываем необходимое для выполнения задачи, настроим в нем по пути /status отдачу страницы статуса сервера nginx.                                            
![Дописаный nginx.conf](Screenshots/2_2.jpg) <br>Исправленный nginx.conf<br>
 
 `location /status { ... }`: начинает блок конфигурации для обработки запросов к пути /status.
 
 `stub_status on;`: включает отдачу статуса сервера Nginx по пути /status.

Скопировал созданный файл *nginx.conf* внутрь докер-образа через команду `docker cp nginx.conf barkopen:/etc/nginx/nginx.conf`  
Проверил, что файл скопировался через `docker exec -it barkopen cat /etc/nginx/nginx.conf`                                                                       
![docker cp nginx.conf / docker exec](Screenshots/2_3.jpg) <br>Проверяем исправленный nginx.conf<br>

Перезапустил **nginx** внутри докер-образа через команду `docker exec barkopen nginx -s reload`                                                                    
![docker exec reload](Screenshots/2_3_1.jpg) <br>Пререзапуск<br>


Проверил, что по адресу `localhost:80/status` выдается страничка со статусом сервера **nginx** в тексовом браузере.                                          
![links2](Screenshots/2_4.jpg)<br>Link<br> 

Также проверил выдачу страници в браузере Chrome.                                                                                                
![http://localhost/status  /  http:// 10.31.170.216/status](Screenshots/2_5.jpg )<br>Вывод по запросу<br> 


</p>
</details>  


<details>
  <summary>Сохраняем настройки с помощью export и import</summary>
</p>

Экспортировал контейнер в архив *container.tar* командой `docker export barkopen > container.tar`                                                               
![export](Screenshots/2_6.jpg)<br>Экспортируем<br>

1. Остановил контейнер командой `docker stop barkopen`, проверил статус командой `docker ps -a`   
2. Удалил образ через `docker rmi -f nginx`, проверил через `docker images`     
3. Удалил остановленный контейнер командой `docker rm barkopen`, проверил через `docker ps -a`                                                                    
![stop / rmi / rm](Screenshots/2_8.jpg)<br>Дейстрия 1 - 3 <br>

Импортировал контейнер обратно командой `docker import container.tar my_image:latest`  и проверил `docker images`                                          
![import container.tar](Screenshots/2_9.jpg)<br>Импортировал контейнер<br>

Запустил импортированный контейнер командой `docker run -d -p 80:80 -p 443:443 --name barkopen my_image:latest nginx -g 'daemon off;'`
проверил через `docker ps.                                                                                                                                   
![docker run](Screenshots/2_10.jpg)<br>Запустил и проверил<br>

Проверил, что по адресу *localhost:80/status* выдается страничка со статусом сервера **nginx**.                                                             
![http://localhost/status  /  http:// 10.31.170.216/status](Screenshots/2_11.jpg)<br>Выдача по запросу<br> 


</p>
</details>



## Part 3. Мини веб-сервер

<details>
  <summary>Отчет по мини-серверу</summary>
</p>

Пишем мини сервер на C и FastCgi, который будет возвращать простейшую страничку с надписью 'Hello World!',                                                       
![Hello_World](Screenshots/3_2.jpg)<br>Вариант мини сервера на С<br>

Пишем свой nginx.conf, который будет проксировать все запросы с 81 порта на 127.0.0.1:8080                                                                  
![nginx.conf](Screenshots/3_1_1.jpg)<br>nginx.conf<br>

Заходим в контейнер командой docker exec -it [container id/container name] bash
 и в bash, обновляем репозитории, устанавливаем gcc, spawn-fcgi и libfcgi-dev                                                                                   
![docker exec](Screenshots/3_8.jpg)<br>Вход в контейнер<br>

Скомпилировали написанный мини сервер                                                                                                                           
![gcc](Screenshots/3_9.jpg)<br>Компиляция<br>

Запустили написанный мини сервер через spawn-fcgi на порту 8080
Применили изменения в настройках сервера:                                                                                                                       
![spawn-fcgi / reload](Screenshots/3_10.jpg)<br>Запускаем<br>

 Проверяем, что в браузере по localhost:81 отдается написанная страничка. 
 ![links2](Screenshots/3_11.jpg)<br>Link<br>

 ![links2 / Chrome](Screenshots/3_12.jpg)<br>Выдача по запросу<br>

 Положи файл nginx.conf по пути ./nginx/nginx.conf (это понадобится позже).                                                                                       
![Copy nginx.conf](Screenshots/3_13.jpg)<br>Последняя задача<br>

</p>
</details>




## Part 4. Свой докер  

<details>
  <summary>Создаём докер-образ для созданного сервера</summary>
</p>

Напишем Dockerfile.                                                                                                                                        

![Dockerfile](Screenshots/4_1.jpg)<br>Dockerfile<br>

Соберём написанный докер-образ через `docker build -t barkopener:part_4 .` указав имя и тег                                                                       
![docker build](Screenshots/4_2.jpg)<br>Сборка образа<br>

Проверил через `docker images`, что все собралось корректно                                                                                               
![docker images](Screenshots/4_3.jpg)<br>Проверяем наличие собранного образа<br>

</p>
</details>




<details>
  <summary>Запуск образа</summary>
</p>


Запустим собранный докер-образ с маппингом 81 порта на 80 на локальной машине и маппингом папки *./nginx* внутрь контейнера по адресу, где лежат конфигурационные файлы **nginx**'а командой `docker run -d -p 80:81 -v "$(pwd)/nginx/nginx.conf:/etc/nginx/nginx.conf" my_fastcgi_server:part_4`  
Проверил, что по *localhost:80* доступна страничка написанного мини сервера                                                                                     
![docker images](Screenshots/4_4.jpg)<br>Запуск образа<br>

![docker images](Screenshots/3_12.jpg)<br>Результат выдачи<br>

</p>
</details>


<details>
  <summary>Допиши в ./nginx/nginx.conf проксирование странички /status, 
  по которой надо отдавать статус сервера nginx.</summary>
</p>


Дописал в *./nginx/nginx.conf* проксирование странички */status*, по которой надо отдавать статус сервера.                                                       
![docker images](Screenshots/4_5.jpg)<br>Изменения в nginx.conf<br>


Перезапустил контейнер командой `docker restart <CONTAINER_NAME>`     
*после сохранения файла и перезапуска контейнера, конфигурационный файл внутри докер-образа обновился*  
Проверил, что теперь по *localhost:80/status* отдается страничка со статусом                                                                                
![links2 http:// ](Screenshots/4_6.jpg)<br>Link<br>

![docker restart / http:// ](Screenshots/4_7.jpg)<br>Результат выдачи<br>
 
</p>
</details>



## Part 5. **Dockle**  

<details>
  <summary>Проверка образа на безопасность с помощью Dockle</summary>
</p>

Устанавливаем Dockle. Инструкцию смотрел тут https://habr.com/ru/companies/timeweb/articles/561378/                                                            
![Установка](Screenshots/5_1.jpg)<br>Установка<br>


Просканировал образ из предыдущего задания через `dockle barkopen:part_4`                                                                                       
![dockle](Screenshots/5_2.jpg)<br>Выявили ошибки<br>

Исправил образ так, чтобы при проверке через **dockle** не было ошибок и предупреждений                                                                         

![Dockerfile](Screenshots/5_3.jpg)<br>Обновлённый Докерфайл<br>   

Для решения ошибки **FATAL - CIS-DI-0010**  использовал команду с `dockle --ak NGINX_GPGKEY --ak NGINX_GPGKEY_PATH`,  которая позволяет подтвердить использование конкретных ключей для работы нашего nginx сервера    
Для фикса по рекомендации **INFO - CIS-DI-0005** использовал команду `export DOCKER_CONTENT_TRUST=1`  
я.   

Написал run.sh 
![run.sh](Screenshots/5_4.jpg)<br>Добавленный скрипт<br>                                                                                                          

Сборка докер-образа и проверка его работоспособности с помощью dockle                                                                                        
![dockle](Screenshots/5_10.jpg)<br>Перепроверили после изменений<br>


</p>
</details>

## Part 6. Базовый **Docker Compose**


<details>
  <summary>Отчёт</summary>
</p>

Устанавливаем docker-compose                                                                                                                                      
![Install](Screenshots/6_0.jpg)<br>Установка<br>

Парвим nginx.conf который будет проксировать все запросы с 8080 порта на 81 порт первого контейнера. 
![nginx.conf](Screenshots/6_1_1.jpg)<br>Дописали nginx.conf<br>


Пишим простой файл `docker-compose.yml`                                                                                                                       
![docker-compose](Screenshots/6_1.jpg)<br>Docker-compose.yml<br>

Поднимаем контэйнеры используя команду docker-compose up -d задав имена  nginx_proxy  и  part_6                                                                  
![docker-compose up](Screenshots/6_2.jpg)<br>Свежие контейнерыbr>

Останавил контейнеры командой `down`                                                                                                                           
![down](Screenshots/6_3.jpg)<br>Остонока контейнеров<br>


Внёс изменения в файл `docker-compose.yml` , так как в дальнейшем будим билдить образы.                                                                          
![docker-compose.yml](Screenshots/6_4.jpg)<br>Обновлённый *.yml <br>

Все готово для использования команды `docker-compose build`                                                                                                
![docker-compose build](Screenshots/6_5_1.jpg)<br>Результат билдинга<br>

Проверяем командой `docker images` наличие образов, и запускаем  `decker-compose up -d`
`docker ps` проверяем , что всё работает                                                                                                                          
![docker images](Screenshots/6_5_2.jpg)<br>Проверяем наличие образов<br>



 
Проверил `curl` и запросом в браузере что всё работает отлично.                                                                                               
![links2 http://localhost:80](Screenshots/6_10.jpg)<br>Результат запросв в браузере<br> 



![cirl -v http://localhost:80](Screenshots/6_22.jpg)<br>Выдача `curl`<br>


 
</p>
</details>
