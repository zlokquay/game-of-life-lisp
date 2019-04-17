;Zachary Taylor, Eamon Kostopolus, Derek Parkinson
;April 17, 2019
;COSC 251 - Programming Languages
;Conway's Game of Life, Lisp Implementation
;Ran on Lispbox Windows 10 environment. Uncomment out the if statement towards the bottom with *steps*
;to add the artificial 100 step limit.

;Setting up variables for the entire lisp program
;(not doing this resulted in crashes)
(defvar *board* 0)
(defvar *neighbors-distance* 0)
(defvar *size* 0)
(defvar *steady-neighbors* 0)
(defvar *live-people* 0)
(defvar *test-case* 0)
(defvar *new-board* 0)
(defvar *2dboard* 0)
(defvar *starting-tiles* 0)
(defvar *necro-neighbors* 0)

;Ripped from the big brain boys at stack overflow. Takes in a 1D list and shuffles it.
;https://stackoverflow.com/questions/49490551/how-to-shuffle-list-in-lisp
(defun nshuffle (sequence)
    (loop for i from (length sequence) downto 2
        do (rotatef (elt sequence (random i))
            (elt sequence (1- i))))
sequence)

;checkDead method
;    @params
;        posx
;           the x index of the current cell
;        posy
;           the y index of the current cell
;Checks the neighbors of the current cell and tallies up how many of them are alive.
;If the amount alive is in the list for how many is required to revive a dead cell,
;then the cell is revived.
(defun checkDead (posx posy)
    (setq *live-people* 0)
    
    (dotimes (*relative-x* (+ (* *neighbors-distance* 2) 1))
        (dotimes (*relative-y*  (+ (* *neighbors-distance* 2) 1))
            (if (equal (aref *board* (mod (- (+ *relative-x* posx) *neighbors-distance*) *size*) (mod (- (+ *relative-y* posy) *neighbors-distance*) *size*)) "A")
                (setq *live-people* (+ *live-people* 1))
            )
        )
    )
    (if (equal nil (find *live-people* *steady-neighbors*))
        (setq *test-case* -1)
        (setq *test-case* (find *live-people* *steady-neighbors*))
    )
    
    (if (= *live-people* *test-case*)
        (setf (aref *new-board* posx posy) "A")
        (setf (aref *new-board* posx posy) "d")
    )
)

;checkStay method
;    @params
;        posx
;           the x index of the current cell
;        posy
;           the y index of the current cell
;Checks the neighbors of the current cell and tallies up how many of them are alive.
;If the amount alive is in the list for how many is required to keep a live cell alive,
;then the cell is kept alive.
(defun checkStay (posx posy)
    (setq *live-people* 0)
    
    (dotimes (*relative-x* (+ (* *neighbors-distance* 2) 1))
        (dotimes (*relative-y*  (+ (* *neighbors-distance* 2) 1))
            (if (equal (aref *board* (mod (- (+ *relative-x* posx) *neighbors-distance*) *size*) (mod (- (+ *relative-y* posy) *neighbors-distance*) *size*)) "A")
                (setq *live-people* (+ *live-people* 1))
            )
            (if (and (equal (- (+ *relative-x* posx) *neighbors-distance*) posx) (equal (- (+ *relative-y* posy) *neighbors-distance*) posy))
                (setq *live-people* (- *live-people* 1))
                ;(princ "hi")
            )
        )
    )
    (if (equal nil (find *live-people* *steady-neighbors*))
        (setq *test-case* -1)
        (setq *test-case* (find *live-people* *steady-neighbors*))
    )
    
    (if (= *live-people* *test-case*)
        (setf (aref *new-board* posx posy) "A")
        (setf (aref *new-board* posx posy) "d")
    )
)

;Setting variables for the Game of Life!
(princ "Enter the size of the board: ")
(setq *size* (read))

(princ "Enter the number of live neighbors for a live cell to stay alive: ")
;This loop is from StackOverflow for converting a string into a list.
;https://stackoverflow.com/questions/7459501/how-to-convert-a-string-to-list-using-clisp?rq=1
(setq *steady-neighbors* (let ((string (read)))
  (loop :for (integer position) := (multiple-value-list 
                                    (parse-integer string
                                                   :start (or position 0)
                                                   :junk-allowed t))
        :while integer
        :collect integer))
)

(princ "Enter the number of live neighbors for a dead cell to become alive: ")
;This loop is from StackOverflow for converting a string into a list.
;https://stackoverflow.com/questions/7459501/how-to-convert-a-string-to-list-using-clisp?rq=1
(setq *necro-neighbors* (let ((string (read)))
  (loop :for (integer position) := (multiple-value-list 
                                    (parse-integer string
                                                   :start (or position 0)
                                                   :junk-allowed t))
        :while integer
        :collect integer))
)

(princ "Enter the distance for the neighbor rule: ")
(loop
    (setq *neighbors-distance* (read))
    (if (< *neighbors-distance* *size*)
        (return 0)
        (princ "ERROR: Neighbor distance bigger than board size; re-enter: ")
    )
)


(princ "Enter number of live tiles to start with: ")
(loop
    (setq *starting-tiles* (read))
    (if (< *starting-tiles* (* *size* *size*))
        (return *starting-tiles*)
    )
    (princ "ERROR: More live tiles than board size; re-enter: ")
)


;Here we make the blank arrays; one of them is only one dimensional.
(setq *board* (make-array (* *size* *size*)))
(setq *2dboard* (make-array (list *size* *size*)))
(setq *new-board* (make-array (list *size* *size*)))

;This loop randomly sets cells to A for alive and d for dead.
(dotimes (i (* *size* *size*)) 
    (if (< i *starting-tiles*)
        (setf (aref *board* i) "A")
    (setf (aref *board* i) "d")
    )
)

;Shuffle the board.
(nshuffle *board*)

;Map the 1d board onto 2d arrays so it's easier to handle with (x, y) coordinates.
(dotimes (i *size*)
    (dotimes (j *size*)
        (setf (aref *2dboard* i j) (aref *board* (+ (* i *size*) j)))
        (setf (aref *new-board* i j) (aref *board* (+ (* i *size*) j)))
    )
)

;reset the 1d array to a 2d array
(setq *board* *2dboard*)

;Main looping starts here, we keep track of steps.
(defvar *steps* 0)
(loop
    ;nested loops to check every index.
    (dotimes (i *size*)
        (dotimes (j *size*)
            ;if it's a d, check to revive. if it isn't, check if it dies.
            (if (equal (aref *board* i j) "d")
                (progn
                    (checkDead i j)
                )
                (progn
                    (checkStay i j)
                )
            )
        )
    )
 
    ;I have a max of 100 steps for testing; remove if you want to go past 100.
    ;(if (= *steps* 100)
    ;    (return 0)
    ;)
    (setq *board* *new-board*)
    (setq *steps* (+ *steps* 1))
 
    ;printing in a cute way.
    (princ "STEP ")
    (princ *steps*)
    (terpri)
    (dotimes (i *size*)
        (dotimes (j *size*)
            (princ (aref *new-board* i j))
            (princ " ")
        )
        (terpri)
    )
    ;our way to get it to go step by step
    (princ "Press \"ENTER\" to continue: ")
    (terpri)
    (terpri)
    (read-line)
)
