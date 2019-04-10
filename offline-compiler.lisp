(princ "Enter the size of the board: ")
(defvar *size* (read))

(princ "Enter the number of live neighbors for a live cell to stay alive: ")
(defvar *steady-neighbors* (read))

(princ "Enter the number of live neighbors for a dead cell to become alive: ")
(defvar *necro-neighbors* (read))

(princ "Enter the distance for the neighbor rule: ")
(loop
    (setq *neighbors-distance* (read))
    (if (< *neighbors-distance* *size*)
        (return *neighbors-distance*)
    )
    (princ "ERROR: Neighbor distance bigger than board size; re-enter: ")
)

(princ "Enter number of live tiles to start with: ")
(loop
    (setq *starting-tiles* (read))
    (if (< *starting-tiles* (* *size* *size*))
        (return *starting-tiles*)
    )
    (princ "ERROR: More live tiles than board size; re-enter: ")
)

(setq *board* (make-array (list *size* *size*)))

(dotimes (i *size*)
    (dotimes (j *size*)
        (setf (aref *board* i j) "d")
    )
)

(princ *board*)
