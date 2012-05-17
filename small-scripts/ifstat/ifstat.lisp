#!/usr/bin/clisp

(format t "~a~%"
	(read-line
	 (ext:run-shell-command
	  "ifstat -i eth1,wlan0 -q 1 1 | tail -n 1"
;	  "ifstat -i wlan0 -q 1 1 | grep -v \"in.*out\" | sed -e ':a;N;s/\s\+\n/:/g' -e 's/\s\+/ /g' -e 's/^\s\+//' -e 's/\.\w\+//g'"
	  :wait nil
	  :output :stream)))
