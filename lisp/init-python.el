;; -*- coding: utf-8; lexical-binding: t; -*-

(setq interpreter-mode-alist
      (cons '("python" . python-mode) interpreter-mode-alist))

;; jedi

(eval-after-load 'python
  '(progn
     ;; run command `pip install jedi flake8 importmagic` in shell,
     ;; or just check https://github.com/jorgenschaefer/elpy
     (elpy-enable)
     ;; http://emacs.stackexchange.com/questions/3322/python-auto-indent-problem/3338#3338
     ;; emacs 24.4 only
     (setq electric-indent-chars (delq ?: electric-indent-chars))))

;;elpy
(when (require 'elpy nil t)
  (elpy-enable)
  (pyvenv-activate "~/opt/virtualenvs/emacs-python")
  (setq elpy-rpc-backend "jedi")
)

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)

;; (defun goto-def-or-rgrep ()
;;   "Go to definition of thing at point or do an rgrep in project if that fails"
;;   (interactive)
;;   (condition-case nil (elpy-goto-definition)
;;     (error (elpy-rgrep-symbol (thing-at-point 'symbol)))))
;; (define-key elpy-mode-map (kbd "M-.") 'goto-def-or-rgrep)

(provide 'init-python)
