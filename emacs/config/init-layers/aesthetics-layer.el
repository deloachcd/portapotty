(provide 'aesthetics-layer)

;; GUI toolbars should already be disabled by the time we load
;; this layer, so we don't need to do it here

(set-fringe-mode 10)

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

;; This function is used to set the fixed and variable pitch fonts, with font
;; size being set relative to display resolution. There's no formula for this
;; at this point, so all resolutions are hardcoded (which will probably look
;; better anyway)
(defun set-fonts-from-display-resolution (fixed-pitch-font variable-pitch-font)
  (progn
    (defun get-display-resolution-windows ()
      "TODO: actually implement this"
      "1920x1080")
    (defun get-display-resolution-linux ()
      (shell-command-to-string "xrandr | grep '*' | awk '{ printf $1 }'"))

	(defun set-fonts-from-heights (fixed-pitch-height variable-pitch-height)
	  (set-face-attribute 'default nil
						  :font fixed-pitch-font :height fixed-pitch-height)
	  (set-face-attribute 'fixed-pitch nil
						  :font fixed-pitch-font :height fixed-pitch-height)
	  (set-face-attribute 'variable-pitch nil
						  :font variable-pitch-font :height variable-pitch-height)
	  (add-to-list 'default-frame-alist (cons 'font 'default))
	  (set-frame-font 'default nil t))

    (let ((resolution (cond ((string-equal system-type "gnu/linux")
							 (get-display-resolution-linux))
							((string-equal system-type "windows-nt")
							 (get-display-resolution-windows)))))

      (cond (;; 4k
			 (string-equal resolution "3840x2160")
			 (set-fonts-from-heights 140 190))

			 ;; 1080p
			((string-equal resolution "1920x1080") ; NOTE: 14 -> 11 original config
			 (set-fonts-from-heights 140 190))

			;; Default case - same as 1080p for now
			(t (set-fonts-from-heights 140 190))))))

(set-fonts-from-display-resolution "FiraCode" "ETBembo")


;; Set default frame size for GUI
(if (display-graphic-p)
	(let ((frame-size-params '((width . 108) (height . 42))))
	  (setq initial-frame-alist frame-size-params)
	  (setq default-frame-alist frame-size-params)))

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
