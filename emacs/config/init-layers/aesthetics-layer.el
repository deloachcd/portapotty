(provide 'aesthetics-layer)

;; Splash screen displayed on startup
(use-package dashboard
  :init
  (setq dashboard-startup-banner "~/.emacs.d/res/img/zenmacs.png")
  (setq dashboard-center-content t)
  (setq dashboard-set-footer nil)
  (setq dashboard-items '((recents . 5)
                          (projects . 5)))
  :config
  (dashboard-setup-startup-hook))

;; I use a few DOOM emacs packages to simplify configuration
(use-package doom-themes)

(use-package zenburn-theme
  :config
  (load-theme 'zenburn t))

(use-package doom-modeline
  :init (setq doom-modeline-icon nil)
  :config (doom-modeline-mode 1))

;; org-mode configuration happens below this line
;; ----------------------------------------------

;; This gives us nice looking bullets in org-mode
;; old value: '("♣" "♠" "♦" "♥")
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :config (setq org-bullets-bullet-list '("✮" "✸" "✱" "❖")))

(defun aesthetics/org-mode-setup ()
  (setq org-hide-emphasis-markers t)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

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
                        :inherit 'variable-pitch :weight 'bold :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  ;; NOTE: describe-text-properties is a godsend for figuring this shit out
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (dolist (face '(org-code
                  org-table
                  org-verbatim))
    (set-face-attribute face nil :inherit '(shadow fixed-pitch)))
  (dolist (face '(org-special-keyword
                  org-meta-line))
    (set-face-attribute face nil :inherit '(font-lock-comment-face fixed-pitch)))
  (dolist (face '(org-checkbox
                  org-document-info-keyword
                  org-drawer
                  org-property-value))
    (set-face-attribute face nil :inherit 'fixed-pitch))

  ;; TODO: maybe fork the theme and set this there?
  (if 'doom-homage-white-active
      (dolist (face '(org-block-begin-line
                      org-block-end-line))
        (set-face-attribute face nil :foreground "#7c7c7c"))))
