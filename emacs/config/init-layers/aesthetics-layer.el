(provide 'aesthetics-layer)

;; Splash screen displayed on startup
(use-package dashboard
  :init
  (setq dashboard-startup-banner 'official)
  (setq dashboard-center-content t)
  (setq dashboard-set-footer nil)
  (setq dashboard-items '((recents . 5)
			  (projects . 5)))
  :config
  (dashboard-setup-startup-hook))

;; I use a few DOOM emacs packages to simplify configuration
(use-package doom-themes
  :config
  (load-theme 'doom-homage-white t))

(use-package doom-modeline
  :init (setq doom-modeline-icon nil)
  :config (doom-modeline-mode 1))

;; org-mode configuration happens below this line
;; ----------------------------------------------

;; This gives us nice looking bullets in org-mode
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :config (setq org-bullets-bullet-list '("♣" "♠" "♦" "♥")))

;; this gets hooked in when we get to org-layer.el
(defun aesthetics/org-font-setup ()
	(dolist (face '((org-document-title . 1.75)
					(org-level-1 . 1.5)
					(org-level-2 . 1.25)
					(org-level-3 . 1.1)
					(org-level-4 . 1.0)
					(org-level-5 . 1.0)
					(org-level-6 . 1.0)
					(org-level-7 . 1.0)
					(org-level-8 . 1.0)))
      (set-face-attribute (car face) nil
						  :font "ETBembo" :weight 'bold :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))
