# based on jpm/shutil.janet by bakpakin

###########################################################################

# Copyright (c) 2021 Calvin Rose and contributors

# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

###########################################################################

(defn is-win
  []
  (= :windows (os/which)))

(defn rm
  "Remove a directory and all sub directories."
  [path]
  (case (os/lstat path :mode)
    :directory (do
      (each subpath (os/dir path)
        (rm (string path "/" subpath)))
      (os/rmdir path))
    nil nil # do nothing if file does not exist
    # Default, try to remove
    (os/rm path)))

(defn rimraf
  "Hard delete directory tree"
  [path]
  (if (is-win)
    # windows get rid of read-only files
    (when (os/stat path :mode)
      (os/shell (string `rmdir /S /Q "` path `"`)))
    (rm path)))

(def path-splitter
  "split paths on / and \\."
  (peg/compile ~(any (* '(any (if-not (set `\/`) 1)) (+ (set `\/`) -1)))))

(defn create-dirs
  "Create all directories needed for a file (mkdir -p)."
  [dest]
  (def segs (peg/match path-splitter dest))
  (def i1 (if (and (is-win) (string/has-suffix? ":" (first segs))) 2 1))
  (for i i1 (length segs)
    (def path (string/join (slice segs 0 i) "/"))
    (unless (empty? path) (os/mkdir path))))

(defn devnull
  []
  (os/open (if (= :windows (os/which)) "NUL" "/dev/null") :rw))

#(defn- patch-path
#  "Add the bin-path to the regular path"
#  [path]
#  (if-let [bp (dyn:binpath)]
#    (string bp (if (= :windows (os/which)) ";" ":") path)
#     path)
#  path)

(defn- patch-env
  []
  (def environ (os/environ))
  # Windows uses "Path"
  (def PATH (if (in environ "Path") "Path" "PATH"))
  (def env (merge-into environ {"JANET_PATH" (os/getenv "JANET_PATH")
                                PATH (os/getenv PATH)})))
  # XXX: patch-path not necessary if not doing `jpm exec`?
  #      https://github.com/janet-lang/jpm/commit/6141bccd05b2de8a7dca1f79ddc39d79daaa86e1
                                #PATH (patch-path (os/getenv PATH))})))

(defn shell
  "Do a shell command"
  [& args]
  # First argument is executable and must not contain spaces, workaround
  # for binaries which have spaces such as `zig cc`.
  (def args (tuple ;(string/split " " (args 0)) ;(map string (slice args 1))))
  (when (dyn :verbose)
    (flush)
    (print ;(interpose " " args)))
  (def env (patch-env))
  (if (dyn :silent)
    (with [dn (devnull)]
      (put env :out dn)
      (put env :err dn)
      (os/execute args :epx env))
    (os/execute args :epx env)))

(defn exec-slurp
  "Read stdout of subprocess and return it trimmed in a string."
  [& args]
  (when (dyn :verbose)
    (flush)
    (print ;(interpose " " args)))
  (def env (patch-env))
  (put env :out :pipe)
  (def proc (os/spawn args :epx env))
  (def out (get proc :out))
  (def buf @"")
  (ev/spawn (:read out :all buf))
  (:wait proc)
  (string/trimr buf))

(defn copy
  "Copy a file or directory recursively from one location to another."
  [src dest]
  (print "copying " src " to " dest "...")
  (if (is-win)
    (let [end (last (peg/match path-splitter src))
          isdir (= (os/stat src :mode) :directory)]
      (shell "C:\\Windows\\System32\\xcopy.exe"
             (string/replace "/" "\\" src)
             (string/replace "/" "\\" (if isdir (string dest "\\" end) dest))
             "/y" "/s" "/e" "/i"))
    (shell "cp" "-rf" src dest)))

(defn copyfile
  "Copy a file one location to another."
  [src dest]
  (print "copying file " src " to " dest "...")
  (->> src slurp (spit dest)))

(defn abspath
  "Create an absolute path. Does not resolve . and .. (useful for
  generating entries in install manifest file)."
  [path]
  (if (if (is-win)
        (peg/match '(+ "\\" (* (range "AZ" "az") ":\\")) path)
        (string/has-prefix? "/" path))
    path
    (string (os/cwd) "/" path)))

(def- filepath-replacer
  "Convert url with potential bad characters into a file path element."
  (peg/compile ~(% (any (+ (/ '(set "<>:\"/\\|?*") "_") '1)))))

(defn filepath-replace
  "Remove special characters from a string or path
  to make it into a path segment."
  [repo]
  (get (peg/match filepath-replacer repo) 0))
