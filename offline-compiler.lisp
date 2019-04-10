(princ "Enter the size of the board: ")
(defvar *size* (read))
(terpri)

(princ "Enter the number of live neighbors for a live cell to stay alive: ")
(defvar *steady-neighbors* (read))
(terpri)

(princ "Enter the number of live neighbors for a dead cell to become alive: ")
(defvar *necro-neighbors* (read))
(terpri)

(princ "Enter the distance for the neighbor rule: ")
(loop
    (setq *neighbors-distance* (read))
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
    (if (< *starting-tiles* (* *size* *size*))
        (return *starting-tiles*)
    )
    (terpri)
    (princ "ERROR: More live tiles than board size; re-enter: ")
)
(terpri)

(setq *board* (make-array (list *size* *size*)))

(dotimes (i *size*)
    (dotimes (j *size*)
        (setf (aref *board* i j) "d")
    )
)

(princ *board*)
