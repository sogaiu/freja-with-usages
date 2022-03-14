(import freja/events :as e)

# pop
(comment

  (let [c (ev/chan 1)]
    (ev/give c :hello)
    (e/pop c))
  # =>
  :hello

  (let [c (ev/chan 1)]
    (e/pop c))
  # =>
  nil

  )

# push!
(comment

  (let [c (ev/chan 1)]
    (ev/give c :hello)
    (e/push! c :smile)
    (e/pop c))
  # =>
  :smile

  (let [c (ev/chan 1)]
    (e/push! c :smile)
    (e/pop c))
  # =>
  :smile

  )

# vs
(comment

  (let [c (ev/chan 2)]
    (e/push! c :hi)
    (e/push! c :there)
    (e/push! c :or-not)
    (e/vs c))
  # =>
  @[:there :or-not]

  )

# pull
(comment

  (def a-number
    (math/rng-int (math/rng (os/cryptorand 2))
                  21))
  (let [res @[]
        #
        pullable (ev/chan 1)
        _ (ev/give pullable a-number)
        #
        puller-1 (fn [v]
                   (array/push res (inc v)))
        puller-2 @{:on-event (fn [tbl v]
                               (array/push res (dec v)))}
        #
        _ (e/pull pullable [puller-1 puller-2])]
    res)
  # =>
  @[(inc a-number) (dec a-number)]

  )

# pull-all
(comment

  (def a-number
    (math/rng-int (math/rng (os/cryptorand 2))
                  21))
  (def other-number
    (math/rng-int (math/rng (os/cryptorand 2))
                  11))
  (let [res @[]
        #
        pullable (ev/chan 2)
        _ (ev/give pullable a-number)
        _ (ev/give pullable other-number)
        #
        puller-1 (fn [v]
                   (array/push res (inc v)))
        puller-2 @{:on-event (fn [tbl v]
                               (array/push res (dec v)))}
        #
        _ (e/pull-all pullable [puller-1 puller-2])]
    res)
  # =>
  @[(inc a-number) (dec a-number)
    (inc other-number) (dec other-number)]

  )

# put!
(comment

  (let [state @{:a 1}]
    (e/put! state :b 2))
  # =>
  @{:a 1
    :b 2
    :event/changed true}

  )

# update!
(comment

  (let [state @{:a 1}]
    (e/update! state :a inc))
  # =>
  @{:a 2
    :event/changed true}

  )

# fresh?
(comment

  (e/fresh? @{:a 1})
  # =>
  nil

  (e/fresh? (e/put! @{:a 1} :b 2))
  # =>
  true

  (let [c (ev/chan 1)]
    (e/fresh? c))
  # =>
  false

  (let [c (ev/chan 1)]
    (ev/give c :smile)
    (e/fresh? c))
  # =>
  true

  )

# pull-deps
(comment

  (let [res @[]
        a-number
        (math/rng-int (math/rng (os/cryptorand 2))
                      21)
        #
        pullable-1 (ev/chan 2)
        _ (ev/give pullable-1 a-number)
        pullable-2 @{:a 1
                     :event/changed true}
        #
        puller-1 (fn [v]
                   (array/push res (inc v)))
        puller-2 @{:on-event (fn [tbl v]
                               (array/push res (v :event/changed)))}]
    (e/pull-deps @{pullable-1 @[puller-1]
                   pullable-2 @[puller-2]})
    #
    (or (deep= res
               @[(inc a-number) false])
        (deep= res
               @[false (inc a-number)])))
  # =>
  true

  )

