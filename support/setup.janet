(defn main
  [& args]
  (def cur-dir (os/cwd))
  (def fj-src
    (slurp (string cur-dir "/support/freja-jaylib.janet")))
  (def bq-src
    (slurp (string cur-dir "/support/bounded-queue.janet")))
  (def fj-dest-path
    (string cur-dir "/freja//jpm_tree/lib/freja-jaylib.janet"))
  (def bq-dest-path
    (string cur-dir "/freja/jpm_tree/lib/bounded-queue.janet"))
  # clean up old stuff
  (when (os/stat fj-dest-path)
    (os/rm fj-dest-path))
  (when (os/stat bq-dest-path)
    (os/rm bq-dest-path))
  # build and install freja
  (os/cd "freja")
  (os/execute ["jpm" "-l" "clean"] :px)
  (os/execute ["jpm" "-l" "deps"] :px)
  (os/execute ["jpm" "-l" "build"] :px)
  (os/execute ["jpm" "-l" "install"] :px)
  # install hook-related code
  (spit fj-dest-path fj-src)
  (spit bq-dest-path bq-src)
  #
  (os/cd cur-dir)
  #
  (print)
  (print "Setup complete.")
  (print)
  (print "Start editor (e.g. emacs) like:")
  (print)
  (print "  JANET_PATH=$(pwd)/freja/jpm_tree/lib emacs usages/freja")
  #
  (os/exit 0))

