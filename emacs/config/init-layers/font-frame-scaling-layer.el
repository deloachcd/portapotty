(provide 'font-frame-scaling-layer)

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
      (shell-command-to-string "xrandr | grep '*' | head -n 1 | awk '{ printf $1 }'"))

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
             (set-fonts-from-heights 150 150))

            ;; 1080p
            ((string-equal resolution "1920x1080")
             (set-fonts-from-heights 120 130))

            ;; Default case - same as 1080p for now
            (t (set-fonts-from-heights 120 130))))))

;; This function sets default params for a frame, and resizes the current frame
;; to that size
(defun set-frame-defaults (frame-width frame-height)
  (if (display-graphic-p)
      (let ((frame-size-params '((width . frame-width) (height . frame-height))))
        (setq initial-frame-alist frame-size-params)
        (setq default-frame-alist frame-size-params)
        (when window-system (set-frame-size (selected-frame) frame-width frame-height)))))

;; We call our functions to apply their changes here
(set-fonts-from-display-resolution "FiraCode" "Noto Sans")
(set-frame-defaults 108 42)
