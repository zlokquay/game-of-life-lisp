;Ripped from the big brain boys at stack overflow.
;https://stackoverflow.com/questions/49490551/how-to-shuffle-list-in-lisp
(defun nshuffle (sequence)
    (loop for i from (length sequence) downto 2
        do (rotatef (elt sequence (random i))
            (elt sequence (1- i))))
sequence)

(princ "Enter the size of the board: ")
(defvar *size* (read))
(princ *size*)
(terpri)

(princ "Enter the number of live neighbors for a live cell to stay alive: ")
(defvar *steady-neighbors* (read))
(princ *steady-neighbors*)
(terpri)

(princ "Enter the number of live neighbors for a dead cell to become alive: ")
(defvar *necro-neighbors* (read))
(princ *necro-neighbors*)
(terpri)

(princ "Enter the distance for the neighbor rule: ")
(loop
    (setq *neighbors-distance* (read))
    (princ *neighbors-distance*)
    (if (< *neighbors-distance* *size*)
        (return *neighbors-distance*)
    )
    (terpri)
    (princ "ERROR: Neighbor distance bigger than board size; re-enter: ")
)
(terpri)


(princ "Enter number of live tiles to start with: ")
(loop
    (setq *starting-tiles* (read))
    (princ *starting-tiles*)
    (if (< *starting-tiles* (* *size* *size*))
        (return *starting-tiles*)
    )
    (terpri)
    (princ "ERROR: More live tiles than board size; re-enter: ")
)
(terpri)

(setq *board* (make-array (* *size* *size*)))
(setq *2dboard* (make-array (list *size* *size*)))
(dotimes (i (* *size* *size*)) 
    (if (< i *starting-tiles*)
        (setf (aref *board* i) "A")
    (setf (aref *board* i) "d")
    )
)

(nshuffle *board*)

(dotimes (i *size*)
    (dotimes (j *size*)
        (setf (aref *2dboard* i j) (aref *board* (+ (* i *size*) j)))
    )
)

(setq *board* *2dboard*)

(princ *board*)
(terpri)
(loop
    (dotimes (i *size*)
        (dotimes (j *size*)
            (if (equal (aref *board* i j) "A")
                (progn
                    (princ "dab")
                    (terpri)
                )
                
                
            )
        )
    )
    (return 0)
)
