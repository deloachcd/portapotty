(provide 'org-layer)

;; Where we'll store all our org documents
(setq org-root "~/Documents/org")

(use-package org
  :hook (org-mode . aesthetics/org-mode-setup)
  :config (aesthetics/org-font-setup))

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory (concat org-root "/roam"))
  :config
  (org-roam-setup)
  (setq org-M-RET-may-split-line nil))

(setq org-agenda-files (concat org-root "/agenda"))

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
     (list (ido-completing-read "Source code type: " src-code-types))))
  (progn
    (newline-and-indent)
    (insert (format "#+BEGIN_SRC %s\n" src-code-type))
    (newline-and-indent)
    (insert "#+END_SRC\n")
    (previous-line 2)
    (org-edit-src-code)))

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
 )
