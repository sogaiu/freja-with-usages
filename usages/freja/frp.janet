# XXX: the "real" freja-jaylib is "hooked" via freja-jaylib.janet
(import ../../freja/freja/frp)
(import ../../support/bounded-queue :as bq)

# trigger
(comment

  (frp/init-chans)

  (def mpq (bq/make-bounded-queue 3))

  (bq/push mpq [100 100])
  (bq/push mpq [100 101])
  (bq/push mpq [100 102])

  (setdyn :mouse-position mpq)

  (frp/trigger 0)

  mpq
  # =>
  @{:capacity 3
    :full false
    :items
    @[[100 100] [100 101] [100 102]]
    :read-i 2
    :write-i 0}
  
  )

# subscribe!
(comment

  (frp/init-chans)

  (def q-size 8)
  (def n-items 10)
  
  (def mpq (bq/make-bounded-queue q-size))

  (each y (range 100 (inc (+ 100 n-items)))
    (bq/push mpq [100 y]))

  (setdyn :mouse-position mpq)

  (def res @[])

  (frp/subscribe! frp/mouse |(array/push res $))

  (frp/trigger 0)

  (get res 0)
  # =>
  @[:mouse-move [100 104]]
 
  (frp/trigger 1)

  (get res 1)
  # =>
  @[:mouse-move [100 106]]

  )

