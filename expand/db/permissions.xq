xquery version "3.1";

declare namespace xmldb="http://exist-db.org/xquery/xmldb";
declare namespace sm="http://exist-db.org/xquery/securitymanager";


declare function local:apply($main-collection as xs:string) as xs:anyURI* {
let $main-collection := "/db/apps/test-expand"
let $group-name := "guest"

(: let $collections := xmldb:get-child-collections($main-collection) :)
let $resources := xmldb:get-child-resources($main-collection)

(: let $done := sm:chgrp(xs:anyURI($main-collection), $group-name) :)

let $done := for $resource in $resources
    let $uri := xs:anyURI($main-collection || "/" || $resource)
    let $is-xquery := matches($resource, "\.xq?")
    return 
        if($is-xquery) then
            (sm:chgrp($uri, $group-name),
             sm:chmod($uri, "rw-r-xr--"),
             $uri)  (: "rw-r--r--" :)
         else ()

return $done
};

local:apply("/db/apps/test-expand")
