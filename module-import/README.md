# Module import

Test application for module import

XQuery library containing multiple XQuery modules with dependencies. XQuery modules are registered in the [EXPath package file](./src/expath-pkg.xml):

```xml
<xquery>
 <namespace>https://daliboris.cz/exist-db/test/main-module</namespace>
 <file>main-module.xqm</file>
</xquery>

<xquery>
 <namespace>https://daliboris.cz/exist-db/test/imported-module</namespace>
 <file>imported-module.xqm</file>
</xquery>
```

In eXist-db 6.2.0, calling function in main module imported only by namespace (i.e. without location hint) fails with `err:XQST0059 error`.

Steps to reproduce:

1. Build a module

```script
ant
```

2. Create eXist-db Docker container, install package, execute test query, stop the container

```script
docker run -dit -p 8080:8080 -p 8443:8443 --name test-module-import-6.4.0 existdb/existdb:6.4.0
xst package install local-files ./build/module-import.xar --config ./src/.existdb.json --force
xst execute 'import module namespace mm = "https://daliboris.cz/exist-db/test/main-module";  mm:get-info($collection-path)' -b '{"collection-path": "/db/apps"}'
docker stop test-module-import-6.4.0
```

Returns

```xml
<mm:info xmlns:mm="https://daliboris.cz/exist-db/test/main-module" source="main-module"/>
```

3. Create eXist-db Docker container, install package, execute test query, stop the container

```script
docker run -dit -p 8080:8080 -p 8443:8443 --name test-module-import-6.2.0 existdb/existdb:6.2.0
xst package install local-files ./build/module-import.xar --config ./src/.existdb.json --force
xst execute 'import module namespace mm = "https://daliboris.cz/exist-db/test/main-module";  mm:get-info($collection-path)' -b '{"collection-path": "/db/apps"}'
docker stop test-module-import-6.2.0
```

Returns:

```script
XPathException:
err:XQST0059 error found while loading module mm: Error while loading module : error found while loading module im: Source for module 'https://daliboris.cz/exist-db/test/imported-module' not found module location hint URI 'imported-module.xqm'.
```

