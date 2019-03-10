;;; go-mode
(autoload 'go-mode "go-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.go\\'" . go-mode))


(add-hook 'go-mode-hook (lambda()
                         (local-set-key (kbd "C-c C-r") 'go-remove-unused-imports)))

(add-hook 'flymake-mode-hook
      (lambda()
        (local-set-key (kbd "C-c C-e n") 'flymake-goto-next-error)))
(add-hook 'flymake-mode-hook
      (lambda()
        (local-set-key (kbd "C-c C-e p") 'flymake-goto-prev-error)))
(add-hook 'flymake-mode-hook
      (lambda()
        (local-set-key (kbd "C-c C-e m") 'flymake-popup-current-error-menu)))





;; gocode 自动补全
;; (require 'go-autocomplete)
;; (require 'auto-complete-config)
(ac-config-default);; 全局开启了ac
;; 联想忽略大小写
(setq ac-ignore-case t)

;; 上下选择联想项的快捷键
(setq ac-use-menu-map t)
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)

(defadvice auto-complete-mode (around disable-auto-complete-for-python)
  (unless (eq major-mode 'python-mode) ad-do-it))

(ad-activate 'auto-complete-mode)

;; 保存前格式化代码
(add-hook 'before-save-hook 'gofmt-before-save)

(provide 'init-go)
