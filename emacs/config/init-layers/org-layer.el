(provide 'org-layer)

;; Where we'll store all our org documents
(setq org-root "~/Sync/Documents/org")

(use-package org
  :hook (org-mode . aesthetics/org-mode-setup)
  :config
  (aesthetics/org-font-setup))

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (concat org-root "/roam"))
  :config
  (org-roam-setup)
  (setq org-M-RET-may-split-line nil))

(use-package evil-org
  :after org
  :hook (org-mode . evil-org-mode)
  :config
  (progn
    (require 'evil-org-agenda)
    (evil-org-agenda-set-keys)))

(setq org-agenda-files
      (list (concat org-root "/agenda/tasks.org")
            (concat org-root "/agenda/dates.org")))

;; Hopefully, fix messed up indentation in source code blocks
(setq org-src-fontify-natively t
      org-src-window-setup 'current-window
      org-src-strip-leading-and-trailing-blank-lines t
      org-src-preserve-indentation t
      org-src-tab-acts-natively t
      org-edit-src-content-indentation 0)

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
  "i i" 'org-insert-item
  "i h" 'org-insert-heading
  "i s" 'org-insert-subheading
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
