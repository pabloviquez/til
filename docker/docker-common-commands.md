# Docker Useful & Most Commond Commands

## List all images
```
docker images -a
```

## List all containers
```
docker ps --all
```

# Delete all running containers
```
docker kill $(docker ps -q)
```

## Delete all stopped containers
```
docker rm $(docker ps -a -q)
```

## Delete all images
```
docker rmi $(docker images -q)
```
