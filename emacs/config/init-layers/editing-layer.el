(provide 'editing-layer)
;; This is the primary configuration layer for customizing how emacs
;; behaves as a text editor, mainly through tweaking its own defaults
;; and evil-mode.
;;
;; Much of the ideas here are taken from Witchmacs, by snackon:
;; https://github.com/snackon/Witchmacs

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

;; Indentation
(setq-default tab-width 4)
(setq-default standard-indent 4)
(setq c-basic-offset tab-width)
(setq-default electric-indent-inhibit t)
(setq-default indent-tabs-mode t)
(setq backward-delete-char-untabify-method 'nil)

;; Don't litter every working directory with backups
(defvar backup-dir "~/.emacs.d/backups")
(setq backup-directory-alist (list (cons "." backup-dir)))

;; Copypasting outside of emacs
(setq x-select-enable-clipboard t)

;; Disable ring-bell
(setq ring-bell-function 'ignore)

;; Prettify symbols globally
(global-prettify-symbols-mode t)

;; Bracket pair-matching
(setq electric-pair-pairs '(
			    (?\{ . ?\})
			    (?\( . ?\))
			    (?\[ . ?\])
			    (?\" . ?\")
			    ))
(electric-pair-mode t)

;; Type "y" or "n" instead of "yes" or "no" in minibuffer
(defalias 'yes-or-no-p 'y-or-n-p)
