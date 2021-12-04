FROM openjdk:11.0.13-bullseye

# downloads https://www.rundeck.com/community-downloads
ARG RDECK_IMAGE=rundeck-3.4.6-20211110.war

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1
ENV RUNDECK_SERVER_FORWARDED=true

# add user
RUN useradd --create-home myuser

ENV HOME=/home/myuser/rundeck
ENV RDECK_BASE=$HOME

# mkdir 
RUN mkdir $HOME
WORKDIR $HOME
COPY requirements.txt .
RUN apt-get update && apt-get -y install python3-pip python3-venv git && apt-get autoclean

# chown
RUN chown -R myuser:myuser /home/myuser
USER myuser
RUN python3 -m venv /home/myuser/venv
ENV PATH="/home/myuser/venv/bin:$PATH"
RUN pip install --upgrade pip && pip install -r requirements.txt

# copy war
COPY $RDECK_IMAGE rundeck.war
RUN java -jar rundeck.war --installonly
COPY config server/config

EXPOSE 4440

# entrypoint
ENTRYPOINT ["java", "-jar", "rundeck.war"]

