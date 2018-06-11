(require 'org-page)
(setq op/repository-directory "~/github/Nanue1.github.io")   ;; the repository location
(setq op/site-domain "http://www.manue1.site/")         ;; your domain
(setq op/site-main-title "manue1's site")
(setq op/site-sub-title "^_^ just for simaple")
(setq op/personal-github-link "https://github.com/nanue1")
(setq op/personal-disqus-shortname "manue1-site")    ;; your disqus commenting system
(setq op/personal-google-analytics-id "UA-92179266-1")

(setq op/category-config-alist
      '(("blog" ;; this is the default configuration
         :show-meta t
         :show-comment t
         :uri-generator op/generate-uri
         :uri-template "/blog/%y/%m/%d/%t/"
         :sort-by :date     ;; how to sort the posts
         :category-index t) ;; generate category index or not
        ("wiki"
         :show-meta t
         :show-comment nil
         :uri-generator op/generate-uri
         :uri-template "/wiki/%t/"
         :sort-by :mod-date
         :category-index t)
        ("index"
         :show-meta nil
         :show-comment nil
         :uri-generator op/generate-uri
         :uri-template "/"
         :sort-by :date
         :category-index nil)
        ("about"
         :show-meta nil
         :show-comment nil
         :uri-generator op/generate-uri
         :uri-template "/about/"
         :sort-by :date
         :category-index nil)))

(provide 'init-orgpage)