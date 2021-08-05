(provide 'org-layer)

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Documents/OrgRoam")
  :config
  (org-roam-setup))

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
