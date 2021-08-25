(provide 'org-layer)

;; Where we'll store all our org documents
(setq org-root "~/Sync/Documents/org")

;; Automagically mix variable and monospace fonts
(use-package mixed-pitch
  :init (setq mixed-pitch-set-height t))

(defun org-mode-setup ()
  (setq org-hide-emphasis-markers t)
  (mixed-pitch-mode 1)
  (visual-line-mode 1))

(defun org-font-setup ()
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

  ;; TODO: maybe fork the theme and set this there?
  (if 'doom-homage-white-active
      (dolist (face '(org-block-begin-line
                      org-block-end-line))
        (set-face-attribute face nil :foreground "#7c7c7c"))))

(use-package org
  :hook (org-mode . org-mode-setup)
  :config
  (progn
    (setf org-blank-before-new-entry '((heading . nil) (plain-list-item . nil)))
    (org-font-setup)))

;; old value: '("♣" "♠" "♦" "♥")
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :config (setq org-bullets-bullet-list '("✮" "✸" "✱" "❖")))

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (concat org-root "/roam"))
  (org-roam-dailies-directory "journal/")
  :config
  (org-roam-setup)
  (setq org-M-RET-may-split-line nil))

(use-package evil-org
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (progn
    (require 'evil-org-agenda)
    (evil-org-set-key-theme '(return
                              textobjects
                              insert
                              navigation
                              additional
                              shift
                              todo
                              heading))
    (evil-org-agenda-set-keys)))

(setq org-agenda-files
      (list (concat org-root "/agenda/tasks.org")
            (concat org-root "/agenda/dates.org")))

;; Hopefully, fix messed up indentation in source code blocks
(setq org-src-fontify-natively t
      org-src-strip-leading-and-trailing-blank-lines t
      org-src-tab-acts-natively t)

;; Source: http://wenshanren.org/?p=334
(defun org-insert-src-block (src-code-type)
  "Insert a `SRC-CODE-TYPE' type source code block in org-mode."
  (interactive
   (let ((src-code-types
          '("emacs-lisp" "python" "C" "sh" "java" "js" "clojure" "C++" "css"
            "calc" "asymptote" "dot" "gnuplot" "ledger" "lilypond" "mscgen"
            "octave" "oz" "plantuml" "R" "sass" "screen" "sql" "awk" "ditaa"
            "haskell" "latex" "lisp" "matlab" "ocaml" "org" "perl" "ruby"
            "scheme" "sqlite")))
     (list (ivy-completing-read "Source code type: " src-code-types))))
  (progn
    (newline-and-indent)
    (insert (format "#+BEGIN_SRC %s\n" src-code-type))
    (newline-and-indent)
    (insert "#+END_SRC\n")
    (previous-line 2)
    (org-edit-src-code)))

(defun org-agenda-edit-tasks ()
  (interactive)
  (find-file (concat org-root "/agenda/tasks.org")))

(defun org-agenda-edit-dates ()
  (interactive)
  (find-file (concat org-root "/agenda/dates.org")))

;; keybinds
(general-create-definer org-bindings
  :prefix "SPC o"
  :states '(normal emacs)
  :keymaps 'override)

(org-bindings
  ;; insertion
  ;; "i i" 'org-insert-item        DEPRECATED: use RET instead
  ;; "i h" 'org-insert-heading     DEPRECATED: use O instead
  ;; "i s" 'org-insert-subheading  DEPRECATED: use M-O instead
  "i l" 'org-insert-link
  "i c" 'org-insert-src-block
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
  ;; editing source code
  "e c" 'org-edit-special
  ;; switch to tasks file
  "a t" 'org-agenda-edit-tasks
  "a d" 'org-agenda-edit-dates
  )
