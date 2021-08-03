(provide 'general-keybinds-layer)

;; Bail out of prompts with ESC
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Window navigation bindings commonly need to be entered more
;; than once to get to the right window, so all window-related bindings
;; are Alt bindings without multiple keystrokes
(global-set-key (kbd "M-/") 'split-window-right)
(global-set-key (kbd "M--") 'split-window-below)
(global-set-key (kbd "M-h") 'windmove-left)
(global-set-key (kbd "M-j") 'windmove-down)
(global-set-key (kbd "M-k") 'windmove-up)
(global-set-key (kbd "M-l") 'windmove-right)

;; General provides a unified interface for key definitions,
;; perfect for spacemacs-style bindings with evil mode
(use-package general)

(general-create-definer root-bindings
  :prefix "SPC"
  :states '(normal emacs)
  :keymaps 'override)

(root-bindings
 "SPC" 'execute-extended-command)

;; TODO: SPC e as general eval layer, not just elisp
(general-create-definer elisp-bindings
  :prefix "SPC e"
  :states '(normal emacs)
  :keymaps 'override)

(elisp-bindings
  "b" 'eval-buffer
  "s" 'eval-last-sexp
  "r" 'eval-region)

(general-create-definer buffer-management-bindings
  :prefix "SPC b"
  :states '(normal emacs)
  :keymaps 'override)
(buffer-management-bindings
 "s" 'ivy-switch-buffer
 "n" 'next-buffer
 "p" 'previous-buffer
 "k" 'kill-buffer)

(defun dotfile-reload ()
  "Reloads emacs configuration from init.el"
  (interactive)
  (load-file "~/.emacs.d/init.el"))

(general-create-definer file-bindings
  :prefix "SPC f"
  :states '(normal emacs)
  :keymaps 'override)
(file-bindings
  "f" 'find-file
  "dR" 'dotfile-reload)

(general-create-definer help-bindings
  :prefix "SPC h"
  :states '(normal emacs)
  :keymaps 'override)
(help-bindings
  "k" 'describe-key
  "f" 'describe-function
  "v" 'describe-variable
  "a" 'apropos)

(general-create-definer shell-bindings
  :prefix "SPC s"
  :states '(normal emacs visual)
  :keymaps 'override)
(shell-bindings
 "m" 'sh-mode
 "e" 'eshell
 "s" 'shell)

;; these are here for the sake of consistency - Alt bindings
;; ought to be more commonly used for their convenience
(general-create-definer window-management-bindings
  :prefix "SPC w"
  :states '(normal emacs)
  :keymaps 'override)
(window-management-bindings
  "/" 'split-window-right
  "-" 'split-window-below
  "h" 'windmove-left
  "j" 'windmove-down
  "k" 'windmove-up
  "l" 'windmove-right)
