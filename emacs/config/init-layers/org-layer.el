(provide 'org-layer)

;; Where we'll store all our org documents
(setq org-root "~/Documents/org")

(use-package org
  :hook (org-mode . aesthetics/org-mode-setup)
  :config (aesthetics/org-font-setup))

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (concat org-root "/roam"))
  :config
  (org-roam-setup)
  (setq org-M-RET-may-split-line nil))

(setq org-agenda-files (concat org-root "/agenda"))

;; Hopefully, fix messed up indentation in source code blocks
(setq org-src-fontify-natively t
      org-src-window-setup 'current-window
      org-src-strip-leading-and-trailing-blank-lines t
      org-src-preserve-indentation t
      org-src-tab-acts-natively t)

;; keybinds
(general-create-definer org-bindings
  :prefix "SPC o"
  :states '(normal emacs)
  :keymaps 'override)

(org-bindings
  ;; insertion
  "i i" 'org-insert-item
  "i h" 'org-insert-heading
  "i s" 'org-insert-subheading
  "i l" 'org-insert-link
  ;; org-roam
  "r f" 'org-roam-node-find
  "r i" 'org-roam-node-insert
  "r b" 'org-roam-buffer-toggle
  "r c" 'org-capture-finalize
  ;; following links
  "l n" 'org-open-at-point
  "l p" 'org-mark-ring-goto
  ;; checking boxes
  "t b" 'org-toggle-checkbox
  )
