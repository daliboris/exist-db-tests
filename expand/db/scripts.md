# Useful scripts

```script
xst package list --versions  --applications  --dependencies --config exist.xstrc
xst package list --versions  --libraries  --dependencies --config exist.xstrc
```

## Deleting Docker Container

```script
docker rm test-expand-exist640
docker rm test-expand-exist620
docker rm test-expand-elemental661
docker rm test-expand-elemental721
```

## Databases

```script
docker run -p 8640:8080 -p 6640:8443 --name test-expand-exist640 existdb/existdb:6.4.0
docker run -p 8620:8080 -p 6620:8443 --name test-expand-exist620 existdb/existdb:6.2.0
docker run -p 9661:8080 -p 7661:8443 --name test-expand-elemental661 evolvedbinary/elemental:6.6.1
docker run -p 9721:8080 -p 7721:8443 --name test-expand-elemental721 evolvedbinary/elemental:7.2.1
```

## Complete eXist-db 6.4.0

```script
docker run -p 8640:8080 -p 6640:8443 --name test-expand-exist640 existdb/existdb:6.4.0
xst upload . /db/apps/test-expand/data --include collection.xconf --apply-xconf --config exist.xstrc --verbose
xst upload . /db/apps/test-expand --include test.xq --config exist.xstrc --verbose
xst upload . /db/apps/test-expand --include controller.xql --config exist.xstrc --verbose
xst execute --file permissions.xq --config exist.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/10 --include DamenConvLex-1834-10.xml --config exist.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/100 --include DamenConvLex-1834-100.xml --config exist.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/1000 --include DamenConvLex-1834-1000.xml --config exist.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/10000 --include DamenConvLex-1834-10000.xml --config exist.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/100000 --include DamenConvLex-1834-100000.xml --config exist.xstrc --verbose

```

## Complete eXist-db 6.2.0

```script
docker run -p 8620:8080 -p 6620:8443 --name test-expand-exist620 existdb/existdb:6.2.0
xst upload . /db/apps/test-expand/data/ --include collection.xconf --apply-xconf --config exist-6.2.0.xstrc --verbose
xst upload . /db/apps/test-expand/ --include test.xq --config exist-6.2.0.xstrc --verbose
xst upload . /db/apps/test-expand/ --include controller.xql --config exist-6.2.0.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/10 --include DamenConvLex-1834-10.xml --config exist-6.2.0.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/100 --include DamenConvLex-1834-100.xml --config exist-6.2.0.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/1000 --include DamenConvLex-1834-1000.xml --config exist-6.2.0.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/100000 --include DamenConvLex-1834-100000.xml --config exist.xstrc --verbose
xst execute --file permissions.xq --config exist.xstrc --verbose
```

## Complete Elemental 7.2.1

```script
xst upload . /db/apps/test-expand/data --include collection.xconf --apply-xconf --config elemental-7.2.1.xstrc --verbose
xst upload . /db/apps/test-expand --include test.xq --config elemental-7.2.1.xstrc --verbose
xst upload . /db/apps/test-expand --include controller.xql --config elemental-7.2.1.xstrc --verbose
xst execute --file permissions.xq --config elemental-7.2.1.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/10 --include DamenConvLex-1834-10.xml --config elemental-7.2.1.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/100 --include DamenConvLex-1834-100.xml --config elemental-7.2.1.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/1000 --include DamenConvLex-1834-1000.xml --config elemental-7.2.1.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/10000 --include DamenConvLex-1834-10000.xml --config elemental-7.2.1.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/100000 --include DamenConvLex-1834-100000.xml --config elemental-7.2.1.xstrc --verbose

```

## Uploading individual files

### `Collection.xconf`

```script
xst upload . /db/apps/test-expand/data/ --include collection.xconf --apply-xconf --config exist.xstrc
xst upload . /db/apps/test-expand/data/ --include collection.xconf --apply-xconf --config exist-6.2.0.xstrc
```

### `test.xq`

```script
xst upload . /db/apps/test-expand/ --include test.xq --config exist.xstrc
xst upload . /db/apps/test-expand/ --include test.xq --config exist-6.2.0.xstrc
```

### `Controller.xql`

```script
xst upload . /db/apps/test-expand/ --include controller.xql --config exist.xstrc
xst upload . /db/apps/test-expand/ --include controller.xql --config exist-6.2.0.xstrc
```

### DamenConvLex.A.xml

```script
xst upload ..\data\input /db/apps/test-expand/data/10 --include DamenConvLex-1834-10.xml --config exist.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/100 --include DamenConvLex-1834-100.xml --config exist.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/1000 --include DamenConvLex-1834-1000.xml --config exist.xstrc --verbose
xst upload ..\data\input /db/apps/test-expand/data/100000 --include DamenConvLex-1834-100000.xml --config exist.xstrc --verbose
```

## Change permissions

```script
xst execute 'sm:chgrp(xs:anyURI($path), $group-name)' -b '{"path": "/db/apps/test-expand", "group-name": "guest"}' --config exist.xstrc --verbose
xst execute --file permissions.xq --config exist.xstrc --verbose
```

## Removing individual files

### DamenConvLex

```script
xst remove /db/apps/test-expand/data/DamenConvLex-1834.xml --config exist.guest.xstrc
xst remove /db/apps/test-expand/data/DamenConvLex-1834.xml --config exist-6.2.0.guest.xstrc
```
