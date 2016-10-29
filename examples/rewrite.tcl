#! /usr/bin/env tclsh8.6

package require tanzer
package require tanzer::file::handler

proc usage {} {
    puts stderr "usage: $::argv0 port root"
    exit 1
}

if {$argc != 2} {
    usage
}

lassign $::argv port root

set server [::tanzer::server new [list \
    port  $port \
    proto "http" \
]]

set fileHandler [::tanzer::file::handler new [list \
    root     $root \
    listings 1]]

$server route {.*} /* {.*} apply {
    {handler event session args} {
        [$session request] rewrite {.*} {/tnzr.png}

        $handler $event $session {*}$args
    }
} $fileHandler

set listener [socket -server [list $server accept] $port]
vwait forever
