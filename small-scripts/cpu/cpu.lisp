#!/usr/bin/clisp

;; copy from stumpwm's contrib code

(defvar *prev-user-cpu* 0)
(defvar *prev-sys-cpu* 0)
(defvar *prev-idle-cpu* 0)
(defvar *prev-iowait* 0)
(defvar *prev-result* '(0 0 0))
(defvar *prev-time* 0)

;; More or less yanked from the wiki.
(defun current-cpu-usage ()
  "Return the average CPU usage since the last call.  First value is percent
of CPU in use.  Second value is percent of CPU in use by system processes.
Third value is percent of time since last call spent waiting for IO (or 0 if
not available). Don't make calculation more than once a second."
  (let ((cpu-result 0)
        (sys-result 0)
        (io-result nil)
        (now (/ (get-internal-real-time) internal-time-units-per-second)))
    (when (>= (- now *prev-time*) 1)
      (setf *prev-time* now)
      (with-open-file (in #P"/proc/stat" :direction :input)
        (read in)
        (let* ((norm-user (read in))
               (nice-user (read in))
               (user (+ norm-user nice-user))
               (sys (read in))
               (idle (read in))
               (iowait (or (ignore-errors (read in)) 0))
               (step-denom (- (+ user sys idle iowait)
                              (+ *prev-user-cpu* *prev-sys-cpu* *prev-idle-cpu* *prev-iowait*))))
          (setf cpu-result (/ (- (+ user sys)
                                 (+ *prev-user-cpu* *prev-sys-cpu*))
                              step-denom)
                sys-result (/ (- sys *prev-sys-cpu*)
                              step-denom)
                io-result (/ (- iowait *prev-iowait*)
                             step-denom)
                *prev-user-cpu* user
                *prev-sys-cpu* sys
                *prev-idle-cpu* idle
                *prev-iowait* iowait
                *prev-result* (list cpu-result sys-result io-result))))))
  (apply 'values *prev-result*))

(defun fmt-cpu-usage (time)
  "Returns a string representing current the percent of average CPU
  utilization."
  (current-cpu-usage)
  (sleep time)
  (let ((cpu (truncate (* 100 (current-cpu-usage)))))
    (format t "CPU: ~3D% " cpu)))

(fmt-cpu-usage 1)