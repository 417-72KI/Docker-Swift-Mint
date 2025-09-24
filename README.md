# [![Docker Hub](http://dockeri.co/image/41772ki/swift-mint)](https://hub.docker.com/r/41772ki/swift-mint)

Docker image for Mint (Swift)

# What's Mint?
Mint is a package manager that installs and runs Swift command line tool packages.

See https://github.com/yonaskolb/Mint

Copyright (c) 2017 Yonas Kolb  
Released under the MIT license  
https://github.com/yonaskolb/Mint/blob/master/LICENSE

# Usage

Supported Swift version is 5.10 ~ 6.2

## Shell

```sh
$ docker pull 41772ki/swift-mint:{swiftVersion}
$ docker run -it 41772ki/swift-mint
```

## Dockerfile

```ruby:Dockerfile
FROM 41772ki/swift-mint:{swiftVersion}
```
