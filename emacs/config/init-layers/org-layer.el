(provide 'org-layer)

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Documents/Org")
  :config
  (org-roam-setup))
