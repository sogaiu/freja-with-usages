(import freja-jaylib :as fj)

(import freja/hiccup :as h)
(import freja/fonts)
(import freja/assets)

(comment

  (do 
    # XXX: necessary for font stuff -- core dumps if not done
    (fj/init-window 1 1 "hiccup new-layer usage")
    # following lives in `do` to prevent overwhelming output
    (assets/register-font "Poppins"
                          :style :regular
                          :ext ".otf"
                          :data fonts/poppins)
    1)
  
  (def props @{})

  (defn sample-hiccup
    [props & _]
    [:padding {:left 600
               :top 30}
     "hello"])

  (def a-layer
    (h/new-layer :sample
                 sample-hiccup
                 props
                 :text/size 22
                 # XXX: without next 2 things, doesn't work
                 :max-width 100
                 :max-height 100))

  (-> a-layer
      keys
      sort)
  # =>
  (-> {:compile 1
       :draw 1
       :hiccup 1
       :max-height 1
       :max-width 1
       :name 1
       :on-event 1
       :props 1
       :render 1
       # associated value is involved
       :root 1
       :tags 1
       :text/size 1}
      keys
      sort)
  
  (-> (a-layer :root)
      keys
      sort)
  # =>
  (-> @{:children 1
        :compilation/children 1
        :compilation/f 1
        :compilation/props 1
        :content-max-height 1
        :content-max-width 1
        :definite-sizing 1
        :f 1
        :height 1
        :inner/element 1
        :layout/lines 1
        :min-height 1
        :min-width 1
        :offset 1
        :props 1
        :relative-sizing 1
        :sizing 1
        :tag 1
        :width 1}
      keys
      sort)

  )

