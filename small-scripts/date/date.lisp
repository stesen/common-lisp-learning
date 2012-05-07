#!/usr/bin/clisp

(defconstant day-names
  '("Mon" "Tue" "Wed" "Thu" "Fri" "Sat" "Sun"))

* (multiple-value-bind
	(second minute hour date month year day-of-week dst-p tz)
      (get-decoded-time)
    (format t "~a ~d-~2,'0d-~2,'0d ~2,'0d:~2,'0d:~2,'0d"
	    (nth day-of-week day-names)
	    year month date
	    hour minute second))