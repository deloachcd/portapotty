(provide 'ide-layer)


;; Primary autocompletion engine
(use-package company)
(use-package lsp-mode :commands lsp)
(use-package lsp-ui
  :hook (lsp-ui-mode . (lambda () (progn
                               (setq lsp-ui-doc-enable nil)
                               (setq lsp-ui-doc-position 'bottom)
                               (setq lsp-ui-doc-alignment 'window))))
  :commands lsp-ui-mode)

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

;; Python specific configuration
(defun python-mode-hook-additions ()
  (electric-pair-local-mode)
  (lsp))

(add-hook 'python-mode-hook 'python-mode-hook-additions)

;; LSP keybinds
(general-create-definer lsp-bindings
  :prefix "SPC l"
  :states '(normal emacs)
  :keymaps 'override)

(lsp-bindings
  "d" 'lsp-ui-doc-mode)
