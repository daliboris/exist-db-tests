xquery version "3.1";

import module namespace xmldb = "http://exist-db.org/xquery/xmldb";
import module namespace sm = "http://exist-db.org/xquery/securitymanager";

declare namespace repo = "http://exist-db.org/xquery/repo";


(: The following external variables are set by the repo:deploy function :)

(: file path pointing to the exist installation directory :)
declare variable $home external;
(: path to the directory containing the unpacked .xar package :)
declare variable $dir external;
(: the target collection into which the app is deployed :)
declare variable $target external;

declare variable $data-root := "data";

declare variable $proxy-value-regex := "^\-+$";


declare variable $repoxml :=
let $uri := doc($target || "/expath-pkg.xml")/*/@name
let $repo := util:binary-to-string(repo:get-resource($uri, "repo.xml"))
return
  parse-xml($repo)
;

declare function local:mkcol-recursive($collection, $components) {
  if (exists($components)) then
    let $newColl := concat($collection, "/", $components[1])
    return
      (
      if (not(xmldb:collection-available($collection || "/" || $components[1]))) then
        let $created := xmldb:create-collection($collection, $components[1])
        return
          (
          sm:chown(xs:anyURI($created), $repoxml//repo:permissions/@user),
          sm:chgrp(xs:anyURI($created), $repoxml//repo:permissions/@group),
          sm:chmod(xs:anyURI($created), replace($repoxml//repo:permissions/@mode, "(..).(..).(..).", "$1x$2x$3x"))
          )
      else
        (),
      local:mkcol-recursive($newColl, subsequence($components, 2))
      )
  else
    ()
};

(: Helper function to recursively create a collection hierarchy. :)
declare function local:mkcol($collection, $path) {
  local:mkcol-recursive($collection, tokenize($path, "/")[.])
};

declare function local:create-data-collection() {
  if (xmldb:collection-available($data-root)) then
    ()
  else
    if (starts-with($data-root, $target)) then
      local:mkcol($target, substring-after($data-root, $target || "/"))
    else
      ()
};

(:~ 
: Create groups defined in the repo.xml
: <permissions user="-" mode="---------" group="redaction" description="Radactors"/>
~:)
declare function local:create-groups() {
  (: collect groups from definitions only for group :)
  let $group-definitions := $repoxml//repo:permissions[matches(@user, $proxy-value-regex)][matches(@mode, $proxy-value-regex)]
  (: collect *real* user definitions :)
  let $user-definitions := $repoxml//repo:permissions[not(matches(@user, $proxy-value-regex))]
  (: collect groups from user definitions too :)
  let $all-groups := ($group-definitions/@group, $user-definitions/@group, $user-definitions/@groups ! tokenize(., "[\s,;]+"))
  => distinct-values()
  
  let $groups := for $group in $all-groups
  let $group-def := $group-definitions[@group = $group]
  return
    if (exists($group-def))
    then
      $group-def
    else
      <permissions xmlns="http://exist-db.org/xquery/repo" group="{$group}" description="Users in the {$group} group"/>
  for $group in $groups
  let $group-exists := sm:group-exists($group/@group)
  return
    if ($group-exists) then
      $group
    else
      let $created := sm:create-group($group/@group, $group/@description)
      return
        if (sm:group-exists($group/@group)) then
          $group
        else
          "not created: " || $group/@group
};
(:~ 
: Create users defined in the repo.xml
: <permissions user="redactor" password="..." group="tei" mode="rw-rwxr--" groups="redaction annotation" full-name="Redactor" description="Redactor of the edition"/>
~:)
declare function local:create-users() {
  let $new-groups := local:create-groups()
  let $users := $repoxml/*/repo:permissions[not(matches(@user, $proxy-value-regex))][not(matches(@mode, $proxy-value-regex))]
  for $user in $users
  let $user-exists := sm:user-exists($user/@user)
  return
    if ($user-exists) then $user
    else
      let $groups := if (exists($user/@groups)) then
        tokenize($user/@groups, " ")
      else ()
      
      let $created := if (exists($user/@full-name) and exists($user/@description)) then
        sm:create-account($user/@user, $user/@password, $user/@group, $groups, $user/@full-name, $user/@description)
      else
        sm:create-account($user/@user, $user/@password, $user/@group, $groups)
      return
        if (sm:user-exists($user/@user)) then $user/@user
        else "not created: " || $user/@user
};

local:create-users()
