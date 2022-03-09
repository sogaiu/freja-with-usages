(import ../../freja/freja/collision :as c)

# in-rec?
(comment

  (c/in-rec? [5 5] [0 0 10 10])
  # =>
  true

  (c/in-rec? [0 0] [0 0 5 5])
  # =>
  true

  (c/in-rec? [5 5] [0 0 5 5])
  # =>
  true

  (c/in-rec? [0 0] [5 5 10 10])
  # =>
  false

  )

