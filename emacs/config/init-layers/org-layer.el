(provide 'org-layer)

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/Documents/Org")
  :config
  (org-roam-setup))

;; This gives us those nice looking bullets in org-mode
(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
