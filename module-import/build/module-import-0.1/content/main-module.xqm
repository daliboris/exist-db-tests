xquery version "3.1" encoding "utf-8";

module namespace mm = "https://daliboris.cz/exist-db/test/main-module";

(:import module namespace dbutil= "http://exist-db.org/xquery/dbutil" at "/db/apps/eXide/modules/dbutils.xqm";:)
(:import module namespace xmldb = "http://exist-db.org/xquery/xmldb" at "java:org.exist.xquery.functions.xmldb.XMLDBModule";:)
import module namespace im =  "https://daliboris.cz/exist-db/test/imported-module"      at "imported-module.xqm";


declare variable $mm:settings-defaults := map {
  "max-items" : 0,
  "processing-info" : true(),
  "element-to-ignore" : ()
};


declare variable $mm:info-defaults := map {
  "structure" :         im:get-info#3
};


declare %public function mm:get-info($collection-path as xs:string, 
  $compute-functions as map(xs:string, function() as item()),
  $settings as map(*)) as element() {
  <mm:info source="main-module" />
  (: im:get-info($collection-path, $compute-functions, $settings) :)
};


declare %public function mm:get-info($collection-path as xs:string, $settings as map(*)) as element() {
  mm:get-info($collection-path, $mm:info-defaults, $settings)
};


declare %public function mm:get-info($collection-path as xs:string) as element() {
  mm:get-info($collection-path, $mm:info-defaults, $mm:settings-defaults)
};

