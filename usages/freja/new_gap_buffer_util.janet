(import ../../freja/freja/new_gap_buffer_util :as ngbu)

# string->gb
(comment

  (ngbu/string->gb "")
  # =>
  @{:actions @[]
    :caret 0
    :gap @""
    :gap-start 0
    :gap-stop 0
    :redo-queue @[]
    :text @""}

  # XXX: why are :caret, :gap-{start,stop} 1?
  (ngbu/string->gb "0")
  # =>
  @{:actions @[]
    :caret 1
    :gap @""
    :gap-start 1
    :gap-stop 1
    :redo-queue @[]
    :text @"0"}

  (ngbu/string->gb "|0")
  # =>
  @{:actions @[]
    :caret 0
    :gap @""
    :gap-start 0
    :gap-stop 0
    :redo-queue @[]
    :text @"0"}

  (ngbu/string->gb "0|1")
  # =>
  @{:actions @[]
    :caret 1
    :gap @""
    :gap-start 1
    :gap-stop 1
    :redo-queue @[]
    :text @"01"}

  (ngbu/string->gb "first line\n|second line")
  # =>
  @{:actions @[]
    :caret 11
    :gap @""
    :gap-start 11
    :gap-stop 11
    :redo-queue @[]
    :text @"first line\nsecond line"}

  )

