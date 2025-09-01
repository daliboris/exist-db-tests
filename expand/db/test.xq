xquery version "3.1";

declare namespace tei="http://www.tei-c.org/ns/1.0";
declare namespace util="http://exist-db.org/xquery/util";
declare namespace ft="http://exist-db.org/xquery/lucene";
declare namespace request="http://exist-db.org/xquery/request";
declare namespace exist="http://exist.sourceforge.net/NS/exist";

let $query-options :=
    <options>
        <default-operator>and</default-operator>
        <phrase-slop>1</phrase-slop>
        <leading-wildcard>yes</leading-wildcard>
        <filter-rewrite>yes</filter-rewrite>
        <lowercase-expanded-terms>yes</lowercase-expanded-terms>
    </options>
let $start-time := util:system-time()
let $field := request:get-parameter("field", "lemma")
let $query := request:get-parameter("query", "a")
let $collection := request:get-parameter("collection", ())
let $collection := if(empty($collection)) then "" else "/" || $collection
let $start-page := xs:double(request:get-parameter("start-page", 1))
let $per-page := xs:double(request:get-parameter("per-page", 20))
let $expand := xs:boolean(request:get-parameter("expand", "false"))
let $get-items := xs:double(request:get-parameter("items", 0)) (: if 0 use fulltext, otherwise get set number of items :)
let $expand-xincludes := request:get-parameter("expand-xincludes", ())
let $highlight-matches := request:get-parameter("highlight-matches", ())
let $expand-options := if(not($expand) or (empty($expand-xincludes) and empty($highlight-matches))) 
    then ()
    else string-join(
        (
        (if(empty($expand-xincludes)) then "" else "expand-xincludes=" || $expand-xincludes),
        (if(empty($highlight-matches)) then "" else "highlight-matches=" || $highlight-matches)
        ), " "
        )
    

let $hits := if($get-items = 0)
    then collection("/db/apps/test-expand/data" || $collection)//tei:entry[not(parent::tei:entry)]
    [ft:query(., "(" || $field || ":" || $query || ")", $query-options)]
    else
    collection("/db/apps/test-expand/data" || $collection)//tei:entry[position() le $get-items]
let $count := count($hits)
let $hits := subsequence($hits, $start-page, $per-page)
let $hits := if($expand) then 
    if(empty($expand-options)) then
            util:expand($hits)
        else
            util:expand($hits, $expand-options)
    else $hits
let $end-time := util:system-time()
let $duration := $end-time - $start-time
let $matches := $hits//exist:match
let $seconds := hours-from-duration($duration) * 60 * 60 
    + minutes-from-duration($duration) * 60 + seconds-from-duration($duration)
(: https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Server-Timing :)
return
(response:set-header("Server-Timing", "query-processing;dur=" || xs:string($seconds)),
 <tei:div 
    data-seconds="{$seconds}" 
    data-start-time="{$start-time}"
    data-end-time="{$end-time}"
    data-duration="{$duration}" 
    data-count="{count($hits)}" 
    data-count-all="{$count}" 
    data-matches-count="{count($matches)}"
    data-items="{$get-items}" 
    data-per-page="{$per-page}" 
    data-start-page="{$start-page}" 
    data-query="{$query}" 
    data-expand="{$expand}"
    data-expand-options="{$expand-options}">{$hits}</tei:div>
    )