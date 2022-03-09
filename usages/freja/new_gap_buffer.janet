(import ../../freja/freja/new_gap_buffer :as ngb)
(import ../../freja/freja/new_gap_buffer_util :as ngbu)

# min*
(comment

  (ngb/min* 1 2)
  # =>
  1

  (ngb/min* 1 nil)
  # =>
  1

  (ngb/min* nil 1)
  # =>
  1

  # XXX: does this make sense?
  (ngb/min* nil nil)
  # = disabled >
  #nil

  )

# gb-iterate
(comment

  (def nums @[])

  (def chars @[])

  (def text
    ``
    first line
    second line
    ``)

  (def gb (ngbu/string->gb text))

  (ngb/gb-iterate gb 0 (length text) idx char
                  (array/push nums idx)
                  (array/push chars char))

  (= (length nums)
     (length chars)
     (length text))
  # =>
  true

  (= text
     (string/from-bytes ;chars))
  # =>
  true

  )

# index-char-backward-start
(comment

  (def text
    ``
    first line
    |second line
    ``)

  (def gb
    (ngbu/string->gb text))

  (def fib
    (fiber/new (fn []
                 (ngb/index-char-backward-start gb 11))))

  (resume fib)
  # =>
  [11 (chr "s")]

  (resume fib)
  # =>
  [10 (chr "\n")]

  )

# index-char-start
(comment

  (def text
    ``
    first line
    |second line
    ``)

  (def gb
    (ngbu/string->gb text))

  (def fib
    (fiber/new (fn []
                 (ngb/index-char-start gb 0))))

  (resume fib)
  # =>
  [0 (chr "f")]

  (resume fib)
  # =>
  [1 (chr "i")]

  )

# gb-length
(comment

  (def text
    ``
    first line
    |second line
    ``)

  (def gb
    (ngbu/string->gb text))

  (ngb/gb-length gb)
  # =>
  (dec (length text)) # to account for | representing caret

  )

# gb-slice
(comment

  (def text
    ``
    first line
    |second line
    ``)

  (def gb
    (ngbu/string->gb text))

  (ngb/gb-slice gb 0 10)
  # =>
  @"first line"

  (ngb/gb-slice gb 11 (length text))
  # =>
  @"second line"

  (ngb/gb-slice gb 9 12)
  # =>
  @"e\ns"

  )

# gb-nth
(comment

  (def text
    ``
    first line
    |second line
    ``)

  (def gb
    (ngbu/string->gb text))

  (ngb/gb-nth gb 9)
  # =>
  (chr "e")

  (ngb/gb-nth gb 10)
  # =>
  (chr "\n")

  (ngb/gb-nth gb 11)
  # =>
  (chr "s")

  )

# commit!
(comment

  )

# put-caret
(comment

  (def text
    ``
    |first line
    second line
    ``)

  (def gb
    (ngbu/string->gb text))

  (gb :caret)
  # =>
  0

  (ngb/put-caret gb 10)

  (gb :caret)
  # =>
  10

  )

# update-caret
(comment

  (def text
    ``
    |first line
    second line
    ``)

  (def gb
    (ngbu/string->gb text))

  (gb :caret)
  # =>
  0

  (ngb/update-caret gb inc)

  (gb :caret)
  # =>
  1

  (ngb/update-caret gb + 9)

  (gb :caret)
  # =>
  10

  (ngb/update-caret gb - 5)

  (gb :caret)
  # =>
  5

  )

# word-at-index
(comment

  (def text "hello there, ant")

  (def gb
    (ngbu/string->gb text))

  (def [b0 e0]
    (ngb/word-at-index gb 0))

  (string/slice text b0 e0)
  # =>
  "hello"

  (def [b1 e1]
    (ngb/word-at-index gb (inc e0)))

  (string/slice text b1 e1)
  # =>
  "there"

  (def [b2 e2]
    (ngb/word-at-index gb (inc e1)))

  # XXX: this seems weird
  (string/slice text b2 e2)
  # = disabled >
  #"there,"

  )

# deselect
(comment

  )

# select-all
(comment

  )

# select-region
(comment

  )

# select-forward-word
(comment

  )

# select-backward-word
(comment

  )

# select-forward-char
(comment

  )

# select-backward-char
(comment

  )

# beginning-of-line?
(comment

  (def text
    ``
    first line|
    next one
    ``)

  (def gb
    (ngbu/string->gb text))

  (ngb/beginning-of-line? gb)
  # =>
  false

  (ngb/put-caret gb 0)

  (ngb/beginning-of-line? gb)
  # =>
  true

  (ngb/put-caret gb (inc 10))

  (ngb/beginning-of-line? gb)
  # =>
  true

  )

# end-of-line?
(comment

  (def text
    ``
    first line|
    next one
    ``)

  (def gb
    (ngbu/string->gb text))

  (ngb/end-of-line? gb)
  # =>
  true

  (ngb/update-caret gb inc)

  (ngb/end-of-line? gb)
  # =>
  false

  (ngb/put-caret gb 0)

  (ngb/end-of-line? gb)
  # =>
  false

  )

# beginning-of-line
(comment

  )

# end-of-line
(comment

  )

# delete-region!
(comment

  (def text
    ``
    fir|st line
    next one
    ``)

  (def gb
    (ngbu/string->gb text))

  (ngb/delete-region! gb 6 16)

  (gb :text)
  # =>
  @"first one"

  )

