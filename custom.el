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
