(provide 'editing-layer)
;; This is the primary configuration layer for customizing how emacs
;; behaves as a text editor, mainly through tweaking its own defaults
;; and evil-mode.
;;
;; Much of the ideas here are taken from Witchmacs, by snackon:
;; https://github.com/snackon/Witchmacs

;; TODO: surround.vim equivalent
;; TODO: leader keybindings - emacs from scratch episode 3

;; Vim-like bindings
(use-package evil
  :init
  (progn
    (setq evil-want-keybinding nil)
    (setq evil-overriding-maps nil
          evil-intercept-maps nil))
  :config (evil-mode t))

;; Make vim-like bindings play nice everywhere
(use-package evil-collection
  :config (evil-collection-init))

(use-package evil-surround)

;; Scroll one line at a time, like it should be
(setq scroll-conservatively 100)

;; Indentation
(setq-default tab-width 4)
(setq-default standard-indent 4)
(setq-default indent-tabs-mode t)
(setq backward-delete-char-untabify-method 'hungry)
(setq c-basic-offset tab-width)

;; Source for these functions here (credit Ye-Chin,Lee):
;; https://www.emacswiki.org/emacs/indent-file.el
(defun indent-whole-buffer ()
  "indent whole buffer and untabify it"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

(defun indent-file-when-save ()
  "indent file when save."
  (make-local-variable 'after-save-hook)
  (add-hook 'after-save-hook
            (lambda ()
              (if (buffer-file-name)
                  (indent-whole-buffer))
              (save-buffer))))

(defun indent-file-when-visit ()
  "indent file when visit."
  (make-local-variable 'find-file-hook)
  (add-hook 'find-file-hook
            (lambda ()
              (if (buffer-file-name)
                  (indent-whole-buffer))
              (save-buffer))))

;; Bracket pair-matching
(setq electric-pair-pairs '((?\{ . ?\})
                            (?\( . ?\))
                            (?\[ . ?\])
                            (?\" . ?\")))

;; Hook for all programming language editing major modes
(add-hook 'prog-mode-hook (lambda ()
                            (display-line-numbers-mode)
                            (hl-line-mode)
                            (show-paren-mode)
                            (company-mode)
                            (indent-file-when-save)
                            (evil-surround-mode)))

;; Hook for text editing major modes, mainly org-mode
(add-hook 'text-mode-hook (lambda ()
                            (hl-line-mode)
                            (show-paren-mode)
                            (evil-surround-mode)))

;; Don't litter every working directory with backups
(defvar backup-dir "~/.emacs.d/backups")
(setq backup-directory-alist (list (cons "." backup-dir)))

;; Copypasting outside of emacs
(setq x-select-enable-clipboard t)

;; Disable ring-bell
(setq ring-bell-function 'ignore)

;; Prettify symbols globally
(global-prettify-symbols-mode t)

;; Type "y" or "n" instead of "yes" or "no" in minibuffer
(defalias 'yes-or-no-p 'y-or-n-p)

;; It's nice to have this available for when we want to see
;; which functions we're using
(use-package command-log-mode)
