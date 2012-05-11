#!/usr/bin/clisp -i ~/.clisprc

;; copy from stumpwm's contrib script

(load "/usr/share/cl-quicklisp/quicklisp.lisp")
(ql:quickload :cl-ppcre)

(defun get-proc-fd-field (s field)
  (if s
      (do ((line (read-line s nil nil) (read-line s nil nil)))
	  ((null line) nil)
	(let ((split (cl-ppcre:split "\\s*:\\s*" line)))
	  (when (string= (car split) field) (return (cadr split)))))
      ""))

(defun mem-usage ()
  "Returns a list containing 3 values:
total amount of memory, allocated memory, allocated/total ratio"
  (let ((allocated 0))
    (multiple-value-bind (mem-total mem-free buffers cached)
	(with-open-file (file #P"/proc/meminfo" :if-does-not-exist nil)
	  (values
	   (read-from-string (get-proc-fd-field file "MemTotal"))
	   (read-from-string (get-proc-fd-field file "MemFree"))
	   (read-from-string (get-proc-fd-field file "Buffers"))
	   (read-from-string (get-proc-fd-field file "Cached"))))
      (setq allocated (- mem-total (+ mem-free buffers cached)))
      (list mem-total allocated (/ allocated mem-total)))))

(defun fmt-mem-usage ()
  "Returns a string representing the current percent of used memory."
  (let* ((mem (mem-usage))
	 (|%| (truncate (* 100 (nth 2 mem))))
	 (allocated (truncate (/ (nth 1 mem) 1000))))
    (format t "MEM: ~4D mb" allocated)))

(fmt-mem-usage)