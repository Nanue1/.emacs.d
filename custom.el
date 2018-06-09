;Org basic configure
(defun manue1/open-gtd-file()
    (interactive)
    (find-file "~/github/note/note-gtd.org")
)
(global-set-key (kbd "<f1>") 'manue1/open-gtd-file)
(global-set-key (kbd "C-c a") 'org-agenda)



(setq org-agenda-files (quote ("~/github/note/note-gtd.org")))
(define-key global-map (kbd "<f2>") 'org-capture)

(setq org-capture-templates
      '(
        ("r" "Read" entry (file+headline "~/github/note/note-gtd.org" "Reading List")
         "* TODO  %?\n  %i\n"
         :empty-lines 1)
        ("w" "Write" entry (file+headline "~/github/note/note-gtd.org" "Writing List")
         "* TODO  %?\n  %i\n"
         :empty-lines 1)
        ("c" "Common" entry (file+headline "~/github/note/note-gtd.org" "Common List")
         "* TODO  %?\n  %i\n"
         :empty-lines 1)
        ("b" "Body" entry (file+headline "~/github/note/note-gtd.org" "Body Building")
         "* TODO  %?\n  %i\n"
         :empty-lines 1)
        ("j" "Job" entry (file+datetree "~/github/job/job-gtd.org" "job notes")
        "* %?\nEntered on %U\n %i\n %a"
        :emptylines 1)
        )
)
; Task state settings
(setq org-todo-keywords
     '((sequence "TODO(t!)" "SOMEDAY(s)" "|" "DONE(d@/!)" "UNDO(u@/!)" "ABORT(a@/!)"))
)
; F3打开job-gtd.org
(defun manue1/open-job-gtd()
    (interactive)
    (find-file "~/github/job/job-gtd.org")
)
(global-set-key (kbd "<f3>") 'manue1/open-job-gtd)

; F5 打开note file
(defun manue1/open-note()
    (interactive)
    (find-file "~/github/note/note-threat_intelligence-开源情报整理.org")
)
(global-set-key (kbd "<f5>") 'manue1/open-note)
; F12 打开自定义配置文件
(defun manue1/open-custom()
    (interactive)
    (find-file "custom.el")
)
(global-set-key (kbd "<f12>") 'manue1/open-custom)

 ;; show line numbers
(add-hook'speedbar-mode-hook'(lambda()(linum-mode-1)))


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