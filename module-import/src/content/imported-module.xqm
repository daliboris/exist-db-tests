xquery version "3.1" encoding "utf-8";

module namespace im =  "https://daliboris.cz/exist-db/test/imported-module";


(:import module namespace util = "http://exist-db.org/xquery/util" at "java:org.exist.xquery.functions.util.UtilModule";:)

declare variable $im:index-name := "structural-index";

declare %public function im:get-info($collection-path as xs:string, 
  $compute-functions as map(xs:string, function() as item()),
  $settings as map(*)) as element()? 
{ 
  <im:info source="imported-module">{$settings?max-items}</im:info>
};
