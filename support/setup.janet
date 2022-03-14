(import ./shutil :as shu)

(defn main
  [& args]
  (def cur-dir (os/cwd))
  #
  (def fj-src
    (slurp (string cur-dir "/support/freja-jaylib.janet")))
  (def bq-src
    (slurp (string cur-dir "/support/bounded-queue.janet")))
  #
  (def jpm-tree
    (string cur-dir "/jpm_tree"))
  (def freja-jpm-tree
    (string cur-dir "/freja/jpm_tree"))
  #
  (def fj-dest-path
    (string cur-dir "/jpm_tree/lib/freja-jaylib.janet"))
  (def bq-dest-path
    (string cur-dir "/jpm_tree/lib/bounded-queue.janet"))
  # clean up old stuff
  (shu/rimraf jpm-tree)
  # build and install freja
  (os/cd "freja")
  (os/execute ["jpm" "-l" "clean"] :px)
  (os/execute ["jpm" "-l" "deps"] :px)
  (os/execute ["jpm" "-l" "build"] :px)
  (os/execute ["jpm" "-l" "install"] :px)
  # copy freja's jpm_tree
  (shu/copy freja-jpm-tree jpm-tree)
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
  (print "  JANET_PATH=$(pwd)/jpm_tree/lib emacs usages/freja")
  #
  (os/exit 0))

