# forcibly load native freja-jaylib
(let [native-loader (get module/loaders :native)
      ext (if (= :window (os/which)) "dll" "so")
      old-env (curenv)
      env (native-loader (string (dyn :syspath) "/freja-jaylib." ext))]
  (merge-module old-env env "" :export))

###########################################################################

(def fj/get-char-pressed get-char-pressed)
(def fj/get-key-pressed get-key-pressed)
(def fj/get-mouse-position get-mouse-position)
(def fj/get-mouse-wheel-move get-mouse-wheel-move)
(def fj/get-screen-height get-screen-height)
(def fj/get-screen-width get-screen-width)
(def fj/measure-text-ex measure-text-ex)

###########################################################################

(import ./bounded-queue :as bq)

###########################################################################

# 0 or keyword (such as :a)
(defn get-char-pressed
  []
  (if-let [cpq (dyn :char-pressed)]
    (if-let [res (bq/pop cpq)]
      res
      0)
    (fj/get-char-pressed)))

# 0 or keyword (such as :a)
(defn get-key-pressed
  []
  (if-let [kpq (dyn :key-pressed)]
    (if-let [res (bq/pop kpq)]
      res
      0)
    (fj/get-key-pressed)))

# 2-tuple of integers
(defn get-mouse-position
  []
  (if-let [mpq (dyn :mouse-position)]
    (if-let [res (bq/pop mpq)]
      res
      # XXX: what to do about this case...
      [0 0])
    (fj/get-mouse-position)))

# -1, 0, or 1
(defn get-mouse-wheel-move
  []
  (if-let [mwmq (dyn :mouse-wheel-move)]
    (if-let [res (bq/pop mwmq)]
      mwmq
      0)
    (fj/get-mouse-wheel-move)))

# positive integer?
(defn get-screen-height
  []
  (if-let [sh (dyn :screen-height)]
    sh
    (fj/get-screen-height)))

# positive integer?
(defn get-screen-width
  []
  (if-let [sh (dyn :screen-width)]
    sh
    (fj/get-screen-width)))

# XXX: change other dynamic variable names to reflect function names too?
(defn measure-text-ex
  [& args]
  (if-let [mte (dyn :measure-text-ex)]
    mte
    (fj/measure-text-ex ;args)))

