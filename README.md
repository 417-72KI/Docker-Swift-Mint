# Docker-Swift-Mint
[![Docker Hub](http://dockeri.co/image/41772ki/swift-mint)](https://hub.docker.com/r/41772ki/swift-mint)

Docker image for Mint (Swift)

# What's Mint?
Mint is a package manager that installs and runs Swift command line tool packages.

See https://github.com/yonaskolb/Mint

# Usage

## Shell

```sh
$ docker pull 41772ki/swift-mint:latest
$ docker run -it 41772ki/swift-mint
```

## Dockerfile

```ruby:Dockerfile
FROM 41772ki/swift-mint:latest
```
