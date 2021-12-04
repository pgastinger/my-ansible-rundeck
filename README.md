# my-ansible-rundeck

https://www.rundeck.com/open-source

## Clone repository
```
peter@Peter-Desktop-2020:/tmp$ git clone git@github.com:pgastinger/my-ansible-rundeck.git
Cloning into 'my-ansible-rundeck'...
remote: Enumerating objects: 17, done.
remote: Counting objects: 100% (17/17), done.
remote: Compressing objects: 100% (13/13), done.
Receiving objects: 100% (17/17), 5.72 KiB | 5.72 MiB/s, done.
remote: Total 17 (delta 0), reused 14 (delta 0), pack-reused 0
peter@Peter-Desktop-2020:/tmp$ cd my-ansible-rundeck/
```

## Download latest rundeck-war-file

https://docs.rundeck.com/download/war/

e.g. 3.4.6:
```
peter@Peter-Desktop-2020:/tmp/my-ansible-rundeck$ wget https://packagecloud.io/pagerduty/rundeck/packages/java/org.rundeck/rundeck-3.4.6-20211110.war/artifacts/rundeck-3.4.6-20211110.war/download -O rundeck.war
--2021-12-04 21:20:09--  https://packagecloud.io/pagerduty/rundeck/packages/java/org.rundeck/rundeck-3.4.6-20211110.war/artifacts/rundeck-3.4.6-20211110.war/download
Resolving packagecloud.io (packagecloud.io)... 54.241.210.185, 52.52.239.191, 2600:1f1c:2e5:6900:6ddc:370:3b46:8f0a, ...
Connecting to packagecloud.io (packagecloud.io)|54.241.210.185|:443... connected.
HTTP request sent, awaiting response... 302 Found
Location: https://d28dx6y1hfq314.cloudfront.net/144/18748/java_artifact/1646086.war?t=1638649510_785b6d9beff36373563b80b5e2b5d80624d6b2fa [following]
--2021-12-04 21:20:10--  https://d28dx6y1hfq314.cloudfront.net/144/18748/java_artifact/1646086.war?t=1638649510_785b6d9beff36373563b80b5e2b5d80624d6b2fa
Resolving d28dx6y1hfq314.cloudfront.net (d28dx6y1hfq314.cloudfront.net)... 54.230.53.189, 54.230.53.200, 54.230.53.46, ...
Connecting to d28dx6y1hfq314.cloudfront.net (d28dx6y1hfq314.cloudfront.net)|54.230.53.189|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 196016752 (187M) [text/plain]
Saving to: ‘rundeck.war’

rundeck.war                                                  100%[==============================================================================================================================================>] 186,94M  19,0MB/s    in 10s     

2021-12-04 21:20:20 (18,6 MB/s) - ‘rundeck.war’ saved [196016752/196016752]
```

## Build container

```
peter@Peter-Desktop-2020:/tmp/my-ansible-rundeck$ docker build -t my-ansible-rundeck:latest .
Sending build context to Docker daemon  196.1MB
Step 1/22 : FROM openjdk:11.0.13-bullseye
 ---> 8c0978077f16
Step 2/22 : ARG RDECK_IMAGE=rundeck.war
 ---> Using cache
 ---> c62b274d959a
Step 3/22 : ENV PYTHONDONTWRITEBYTECODE 1
 ---> Using cache
 ---> 00c852c41f4a
Step 4/22 : ENV PYTHONUNBUFFERED 1
 ---> Using cache
 ---> 84578bc52a90
Step 5/22 : ENV RUNDECK_SERVER_FORWARDED=true
 ---> Using cache
 ---> 52a906145602
Step 6/22 : RUN useradd --create-home myuser
 ---> Using cache
 ---> 7b1b23096d0a
Step 7/22 : ENV HOME=/home/myuser/rundeck
 ---> Using cache
 ---> ed985fca5818
Step 8/22 : ENV RDECK_BASE=$HOME
 ---> Using cache
 ---> 6beed4029239
Step 9/22 : RUN mkdir $HOME
 ---> Using cache
 ---> 62ca9af16b6d
Step 10/22 : WORKDIR $HOME
 ---> Using cache
 ---> 85f54d7701ef
Step 11/22 : COPY requirements.txt .
 ---> Using cache
 ---> 95529f8641e2
Step 12/22 : RUN apt-get update && apt-get -y install python3-pip python3-venv git && apt-get autoclean
 ---> Using cache
 ---> 04dc9a5fc8e0
Step 13/22 : RUN chown -R myuser:myuser /home/myuser
 ---> Using cache
 ---> 5465701b5164
Step 14/22 : USER myuser
 ---> Using cache
 ---> 55a4b6aac1d1
Step 15/22 : RUN python3 -m venv /home/myuser/venv
 ---> Using cache
 ---> 70a581ef0c95
Step 16/22 : ENV PATH="/home/myuser/venv/bin:$PATH"
 ---> Using cache
 ---> da8fe2146314
Step 17/22 : RUN pip install --upgrade pip && pip install -r requirements.txt
 ---> Using cache
 ---> 07dbb35ac127
Step 18/22 : COPY $RDECK_IMAGE rundeck.war
 ---> Using cache
 ---> f035ad4102d4
Step 19/22 : RUN java -jar rundeck.war --installonly
 ---> Using cache
 ---> b3d18fc1e5d3
Step 20/22 : COPY config server/config
 ---> Using cache
 ---> 72a735f67428
Step 21/22 : EXPOSE 4440
 ---> Using cache
 ---> 1e986b9e93dd
Step 22/22 : ENTRYPOINT ["java", "-jar", "rundeck.war"]
 ---> Using cache
 ---> 5bdd965efc7d
Successfully built 5bdd965efc7d
Successfully tagged my-ansible-rundeck:latest

peter@Peter-Desktop-2020:/tmp/my-ansible-rundeck$ docker images
REPOSITORY                                  TAG                IMAGE ID       CREATED              SIZE
my-ansible-rundeck                          latest             5bdd965efc7d   About a minute ago   1.51GB
```

## Run container
```
peter@Peter-Desktop-2020:/tmp/my-ansible-rundeck$ docker-compose up
Starting my-ansible-rundeck_rundeck_1 ... done
Attaching to my-ansible-rundeck_rundeck_1
rundeck_1  | [2021-12-04T20:31:32,386] INFO  rundeckapp.Application - The following profiles are active: production
rundeck_1  | 
rundeck_1  | Configuring Spring Security Core ...
rundeck_1  | ... finished configuring Spring Security Core
rundeck_1  | 
rundeck_1  | [2021-12-04T20:31:49,739] INFO  jvm.JdbcExecutor - SELECT COUNT(*) FROM PUBLIC.DATABASECHANGELOGLOCK
...
rundeck_1  | [2021-12-04T20:31:52,908] INFO  rundeckapp.BootStrap - workflowConfigFix973: No fix was needed. Storing fix application state.
rundeck_1  | [2021-12-04T20:31:53,075] INFO  rundeckapp.BootStrap - Rundeck startup finished in 516ms
rundeck_1  | [2021-12-04T20:31:53,170] INFO  rundeckapp.Application - Started Application in 22.291 seconds (JVM running for 24.252)
rundeck_1  | Grails application running at http://0.0.0.0:4440 in environment: production
```

## Login 
Username admin, password topsecretadminpw
```
http://127.0.0.1/
```
