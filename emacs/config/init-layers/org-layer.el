(provide 'org-layer)

;; Where we'll store all our org documents
(setq org-root "~/Documents/org")

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (concat org-root "/roam"))
  :config
  (org-roam-setup))

(setq org-agenda-files (concat org-root "/agenda"))

;; This gives us those nice looking bullets in org-mode
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

;; keybinds
(general-create-definer org-bindings
  :prefix "SPC o"
  :states '(normal emacs)
  :keymaps 'override)

(org-bindings
 "n f" 'org-roam-node-find
 "n i" 'org-roam-node-insert
 "c" 'org-capture-finalize)
