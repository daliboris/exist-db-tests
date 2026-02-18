# Scripts

## Docker

```script
docker rm test-user-management --force
```

```script
docker run -dit -p 8080:8080 --name test-user-management existdb/existdb:6.4.0
```

### Tests

```script
docker rm test-user-management --force
docker run -dit -p 8080:8080 --name test-user-management existdb/existdb:6.4.0
```

## Building all install packages

```script
ant -file ..\without-script\build.xml
ant -file ..\with-script\build.xml
```

## Copying all install packages

```script
xcopy ..\without-script\build\users-without-script.xar ..\install\deploy\users-without-script.xar /y
xcopy ..\without-script\build\users-with-script.xar ..\install\deploy\users-with-script.xar /y
```

## Build and install on the *local* server

### Users without script

```script
ant     -file   ..\without-script\build.xml
xcopy           ..\without-script\build\users-without-script.xar ..\install\deploy\users-without-script.xar /y
xst     package install ./deploy/users-without-script.xar  --verbose --config .existdb.json
```

### Users with install script

```script
ant     -file   ..\with-script\build.xml
xcopy           ..\with-script\build\users-with-script.xar ..\install\deploy\users-with-script.xar /y
xst     package install ./deploy/users-with-script.xar  --verbose --config .existdb.json
```

### Users with local secrets and install script

```script
ant     -file   ..\with-local-secrets\build.xml create-local.secrets-if-missing
ant     -file   ..\with-local-secrets\build.xml
xcopy           ..\with-local-secrets\build\users-with-local-secrets.xar ..\install\deploy\users-with-local-secrets.xar /y
xst     package install ./deploy/users-with-local-secrets.xar  --verbose --config .existdb.json
```

```script
ant     -file   ..\with-local-secrets\build.xml create-local.secrets-if-missing
```
