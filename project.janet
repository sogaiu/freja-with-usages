(declare-project
  :name "freja-with-usages"
  :url "https://github.com/sogaiu/freja-with-usages"
  :repo "git+https://github.com/sogaiu/freja-with-usages")

(import ./support/setup :as setup)
(phony "setup" []
       (setup/main))

