# Module import

Test application for module import

Build a module

```script
ant
```

Run eXist-db Docker image, install package and execute test query, stop the container

```script
docker run -dit -p 8080:8080 -p 8443:8443 --name test-module-import-6.4.0 existdb/existdb:6.4.0
xst package install local-files ./build/module-import.xar --config ./src/.existdb.json --force
xst execute 'import module namespace mm = "https://daliboris.cz/exist-db/test/main-module";  mm:get-info($collection-path)' -b '{"collection-path": "/db/apps"}'
docker stop test-module-import-6.4.0
```


```script
docker run -dit -p 8080:8080 -p 8443:8443 --name test-module-import-6.2.0 existdb/existdb:6.2.0
xst package install local-files ./build/module-import.xar --config ./src/.existdb.json --force
xst execute 'import module namespace mm = "https://daliboris.cz/exist-db/test/main-module";  mm:get-info($collection-path)' -b '{"collection-path": "/db/apps"}'
docker stop test-module-import-6.2.0
```
