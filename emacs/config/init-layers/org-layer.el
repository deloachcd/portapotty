(provide 'org-layer)

;; Where we'll store all our org documents
(setq org-root "~/Documents/org")

(defun org-mode-setup ()
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :hook (org-mode . org-mode-setup)
  :config
  (aesthetics/org-font-setup))

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (concat org-root "/roam"))
  :config
  (org-roam-setup))

(setq org-agenda-files (concat org-root "/agenda"))

;; keybinds
(general-create-definer org-bindings
  :prefix "SPC o"
  :states '(normal emacs)
  :keymaps 'override)

(org-bindings
 "n f" 'org-roam-node-find
 "n i" 'org-roam-node-insert
 "c" 'org-capture-finalize)
