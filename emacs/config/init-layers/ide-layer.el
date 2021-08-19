(provide 'ide-layer)

;; Primary autocompletion engine
(use-package company)
(use-package lsp-mode :commands lsp)
(use-package lsp-ui :commands lsp-ui-mode)


;; elisp specific configuration
(add-hook 'emacs-lisp-mode-hook 'electric-pair-local-mode)

;; C/C++ specific configuration
(use-package ccls)
(setq ccls-executable "/usr/bin/ccls")
(setq c-basic-offset 4
      c-default-style "stroustrup")

(defun c-mode-hook-additions ()
  (electric-pair-local-mode)
  (lsp))

(add-hook 'c-mode-hook 'c-mode-hook-additions)
(add-hook 'c++-mode-hook 'c-mode-hook-additions)
