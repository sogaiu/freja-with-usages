(defn make-bounded-queue
  [capacity]
  (unless (pos? capacity)
    (errorf "capacity should be positive: %p" capacity))
  #
  @{:items (array/new capacity)
    :capacity capacity
    :read-i 0
    :write-i 0
    :full false})

(comment

  (try
    (make-bounded-queue 0)
    ([e] e))
  # =>
  "capacity should be positive: 0"

  (make-bounded-queue 10)
  # =>
  @{:capacity 10
    :full false
    :items @[]
    :read-i 0
    :write-i 0}

  )

(defn push
  [bqueue item]
  (let [{:capacity c
         :write-i write-i
         :read-i read-i
         :full full} bqueue
        new-i (mod (inc write-i) c)
        full (or full (= new-i read-i))]
    (when full
      (-> bqueue
          (put :full true)
          (put :read-i new-i)))
    #
    (-> bqueue
        (update :items put write-i item)
        (put :write-i new-i))))

(comment

  (push (make-bounded-queue 2) :smile)
  # =>
  @{:capacity 2
    :full false
    :items @[:smile]
    :read-i 0
    :write-i 1}

  (let [bq (make-bounded-queue 2)]
    (-> bq
        (push :smile)
        (push :breathe)
        (push :walk)))
  # =>
  @{:capacity 2
    :full true
    :items @[:walk :breathe]
    :read-i 1
    :write-i 1}

  )

(defn pop
  [bqueue]
  (let [{:capacity c
         :read-i read-i
         :write-i write-i
         :items items
         :full full} bqueue]
    (if (and (= read-i write-i)
             (not full))
      nil
      (let [new-i (mod (inc read-i) c)
            v (items read-i)]
        (-> bqueue
            (put :full false)
            (put :read-i new-i))
        v))))

(comment

  (let [bq (make-bounded-queue 2)]
    (-> bq
        (push :wink)
        (push :fly)
        (push :roll)
        (pop)))
  # =>
  :fly

  )

(defn clear-bounded-queue
  [bqueue]
  (-> bqueue
      (put :full false)
      (put :write-i 0)
      (put :read-i 0)
      (update :items array/clear)))

(comment

  (-> (make-bounded-queue 2)
      (push :smile)
      (push :walk)
      (clear-bounded-queue))
  # =>
  @{:capacity 2
    :full false
    :items @[]
    :read-i 0
    :write-i 0}

  )

