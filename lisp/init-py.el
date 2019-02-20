;; -*- coding: utf-8; lexical-binding: t; -*-

;;; package --- summary or add python emacs mode: elpy
;; add repository

;; elpy-- main actor
(when (require 'elpy nil t)
  (elpy-enable)
  (pyvenv-activate "~/opt/virtualenvs/emacs-python3")
  (setenv "WORKON_HOME" "~/opt/virtualenvs/")
  (setq elpy-rpc-backend "jedi")
  )


;; pyvenv-workon

;; Fixing a key binding bug in elpy
(define-key yas-minor-mode-map (kbd "C-c k") 'yas-expand)
;; Fixing another key binding bug in iedit mode
(define-key global-map (kbd "C-c o") 'iedit-mode)

;; grammal check: flycheck
(add-hook 'after-init-hook #'global-flycheck-mode);global enable
                                        ; close flymake,  start flycheck
(when (require 'flycheck nil t)
  (setq elpy-modules(delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; virutal environment:  virtualenvwrapper
(venv-initialize-interactive-shells)
(venv-initialize-eshell)
;; (setq venv-location "~/pyvirtualenv/"); setup virtual environment folder
;; if there multiple folder:
(setq venv-location '("~/opt/virtualenvs/emacs-python3"
                      "~/opt/virtualenvs/emacs-python"))
;; M-x venv-workon open virtual environment

;;; Commentary:
;; 自动完成
(global-company-mode t); 全局开启

(setq company-idle-delay 0.2;菜单延迟
      company-minimum-prefix-length 1; 开始补全字数
      company-require-match nil
      company-dabbrev-ignore-case nil
      company-dabbrev-downcase nil
      company-show-numbers t; 显示序号
      company-transformers '(company-sort-by-backend-importance)
      company-continue-commands '(not helm-dabbrev)
      )
                                        ; 补全后端使用anaconda
(add-to-list 'company-backends '(company-anaconda :with company-yasnippet))
                                        ; 补全快捷键
(global-set-key (kbd "<C-tab>") 'company-complete)

;; 在python模式中自动启用
(add-hook 'python-mode-hook 'anaconda-mode)

(provide 'init-py)
