#!/usr/bin/clisp

(read-line
 (ext:shell
  "aumix -n get Master 2>/dev/null \ egrep -o \"[0-9]{1,3}%\" | tail -n 1"
  :wait nil
  :output :stream))