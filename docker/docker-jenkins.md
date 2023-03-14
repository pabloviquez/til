# Run and Configure Jenkins

## Links & Docs
* [Jenkins Docker Hub](https://hub.docker.com/r/jenkins/jenkins)
* [Jenkins GitHub Site](https://github.com/jenkinsci/docker)

## About Jenkins
Jenkins will run with the user and group "jenkins", and the home dir is: `/var/jenkins_home`

## Quick Start

The following command will start a Docker instance with the latest Jenkins using the following parameters:

| Parameter Name | Option | Description |
|------|-------|------|
| Name | `--name XXXX` | Container name |
| Expose ports | `-p 8080:8080` | Expose the port 8080 in the VM and binds it to the host 8080. |
| Expose ports | `-p 50000:50000` | Expose the port 50000 in the VM and binds it to the host 50000. |
| Restart policy | `--restart=on-failure` | [Docker provides restart policies](https://docs.docker.com/config/containers/start-containers-automatically/) to control whether your containers start automatically when they exit. |
| Jenkins startup parameter | `--env JAVA_OPTS=-Dhudson.footerURL=http://localhost:8080` | Jenkins startup param. |
| Volumne | `-v data:/var/jenkins_home` | Mounts the Jenkins home (`/var/jenkins_home`) to a local directory (`data`) |
| Image | `jenkins/jenkins:latest` | Latest Jenkins docker image. |

```
docker run \
  -d \
  --name myjenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  --restart=on-failure \
  --env JAVA_OPTS=-Dhudson.footerURL=http://localhost:8080 \
  -v data:/var/jenkins_home \
  jenkins/jenkins:latest
```

## Using Docker Compose

*docker-compose.yml*
```
services:
  myjenkins:
    image: jenkins/jenkins:lts-jdk11
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - data:/var/jenkins_home
    environment:
      - JAVA_OPTS=-Dhudson.footerURL=http://localhost:8080
volumes:
  data:
#
# Alternative
#  data:
#    external: true
```
> **external: true** Specifies that this volume already exist on the platform and its lifecycle
> is managed outside of that of the application. Compose implementations MUST NOT attempt to
> create these volumes, and MUST return an error if they do not exist.
>
> IF external is marked as true, the volume needs to be created first, before the first run.


# Docker Compose Commands

## Start Container
```docker-compose up -d```

## Stop Container
```docker-compose stop```

## Kill Container
```docker-compose kill```

## Show Container Logs
```docker-compose logs```

## Delete Containers
```docker-compose rm -f```

## SSH into the container
```docker-compose run myjenkins bash```

## Re-Construct the VM
```docker-compose build --no-cache --pull```