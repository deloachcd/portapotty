(provide 'editing-layer)

;; Vim-like bindings everywhere
(use-package evil
  :init
  (setq evil-overriding-maps nil
        evil-intercept-maps nil)
  :config (evil-mode t))

;; Vim-like scrolling
(setq scroll-step 1)

;; All prog and text modes will get these hooks
(add-hook 'prog-mode-hook (lambda ()
			    (display-line-numbers-mode)
			    (hl-line-mode)
			    (show-paren-mode)))

(add-hook 'text-mode-hook (lambda ()
			    (hl-line-mode)))
