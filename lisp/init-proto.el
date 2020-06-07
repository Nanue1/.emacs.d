;; proto

(define-derived-mode protobuf-mode c-mode
  "Protocol Buffer" "Major mode for editing Google Protocol Buffer files."
  (setq fill-column 80
          tab-width 4))

(add-to-list 'auto-mode-alist '("\\.proto$" . protobuf-mode))

(provide 'init-proto)