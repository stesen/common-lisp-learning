#!/usr/bin/clisp

(let ((full (open "/sys/class/power_supply/BAT0/charge_full")))
  (defvar full-voltage (read-from-string (read-line full)))
    (close full))

(let ((curr (open "/sys/class/power_supply/BAT0/charge_now")))
  (defvar curr-voltage (read-from-string (read-line curr)))
  (close curr))

(format t "~d%~%"
	(setf percent
	      (floor
	       (/ (* 100 curr-voltage) full-voltage))))