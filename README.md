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
Step 1/21 : FROM openjdk:11.0.13-bullseye
 ---> 8c0978077f16
Step 2/21 : ARG RDECK_IMAGE=rundeck.war
 ---> Using cache
 ---> c062658ac6bc
Step 3/21 : ENV PYTHONDONTWRITEBYTECODE 1
 ---> Using cache
 ---> 6f50d9043eee
Step 4/21 : ENV PYTHONUNBUFFERED 1
 ---> Using cache
 ---> 4f4703830975
Step 5/21 : ENV RUNDECK_SERVER_FORWARDED=true
 ---> Using cache
 ---> 109c2f0beb80
Step 6/21 : RUN useradd --create-home myuser
 ---> Using cache
 ---> dff2d8066980
Step 7/21 : ENV HOME=/home/myuser/rundeck
 ---> Using cache
 ---> dd7183b8e5c8
Step 8/21 : ENV RDECK_BASE=$HOME
 ---> Using cache
 ---> 17a169308327
Step 9/21 : RUN mkdir $HOME
 ---> Using cache
 ---> 154f784c1869
Step 10/21 : WORKDIR $HOME
 ---> Using cache
 ---> ffd42a4ef788
Step 11/21 : COPY requirements.txt .
 ---> Using cache
 ---> 367509eece3e
Step 12/21 : RUN apt-get update && apt-get -y install python3-pip python3-venv git && apt-get autoclean
 ---> Using cache
 ---> e7dca9cce089
Step 13/21 : RUN chown -R myuser:myuser /home/myuser
 ---> Using cache
 ---> 5f8fa4d2ee58
Step 14/21 : USER myuser
 ---> Using cache
 ---> d972e61ba9a4
Step 15/21 : RUN python3 -m venv /home/myuser/venv
 ---> Using cache
 ---> 00daca0d8552
Step 16/21 : ENV PATH="/home/myuser/venv/bin:$PATH"
 ---> Using cache
 ---> 4f7f9f3ee1dc
Step 17/21 : RUN pip install --upgrade pip && pip install -r requirements.txt
 ---> Using cache
 ---> f70f322543a2
Step 18/21 : COPY $RDECK_IMAGE rundeck.war
 ---> Using cache
 ---> e6c868a1cc7e
Step 19/21 : RUN java -jar rundeck.war --installonly
 ---> Using cache
 ---> 62b46a5698c2
Step 20/21 : EXPOSE 4440
 ---> Using cache
 ---> a1345b889ac9
Step 21/21 : ENTRYPOINT ["java", "-jar", "rundeck.war"]
 ---> Using cache
 ---> 2402639ac5b6
Successfully built 2402639ac5b6
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
