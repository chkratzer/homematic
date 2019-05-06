#!/bin/tclsh
#
#   Call function getParamset (via system.Exec)
#   =================================================
#   from an idea of Oliver Wagner <owagner@vapor.com>
#
#   tclsh getparam.tcl <address> <parameter>
#   parameter:
#       - address:		device address of the MASTER like GEQ004711:2
#       - parameter:	parameter name if not present it'll return the list of all available parameters. If no parameter set, it will return all parameters and values. The parameter name are ordered using dictionary acending mode.
#
#   example:
#   tclsh getparam.tcl GEQ004711:2 MODE_TEMPERATUR_REGULATOR
#   return the parameter value.
#
#   This is a version is only working for wireless link. For connected device the port 2001 must be changed on 2000.
#
load tclrpc.so
load tclrega.so
set device [lindex $argv 0]
set item [lindex $argv 1]
array set paramarray {}
#
#
set result [catch {xmlrpc http://127.0.0.1:2001/ getParamset [list string [lindex $argv 0]] [list string "MASTER"] } cmdresult ]
if { !$result} then {
        set resultarray [split $cmdresult " "]
        foreach { desc val } $resultarray {
                set paramarray($desc) $val
        }
        if {$item !=""} then {
                if {[info exists paramarray($item)]} then {
                         puts $paramarray($item)
                }
        } else {
                foreach  key  [lsort -dictionary [array names paramarray]] {
                        puts  "$key=$paramarray($key)"
                }
        }
}
#
