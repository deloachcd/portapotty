(provide 'global-keybinds-layer)

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

(general-create-definer globals
  :prefix "SPC"
  :states '(normal emacs)
  :keymaps 'override)
(globals
  "SPC" 'execute-extended-command
  "eb" 'eval-buffer
  "el" 'eval-last-sexp
  "er" 'eval-region)
