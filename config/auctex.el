;;; config/auctex.el --- Configurations for LaTeX
;;
;; Copyright (C) Akash Jain
;;
;; Author: Akash Jain <ajainphysx@gmail.com>
;; Keywords: latex, auctex, Emacs
;; Homepage: https://ajainphysics.com
;;
;; This file is part of an emacs configuration.
;;

;;; Commentary:
;;
;; This file contains customizations for AUCTeX and dependencies for LaTeX.
;;

;;; Code:

(require 'config/definitions (locate-user-emacs-file "config/definitions.el"))

(require 'latex)
(require 'tex-buf)

;; ========== Frame Sizing =====================================================

(add-hook 'LaTeX-mode-hook
	  (lambda () (modify-frame-parameters nil '((fullscreen . fullheight)))))

;; ========== Basic Settings ===================================================

(setq TeX-parse-self t) ; Enable parse on load
(setq TeX-auto-save t) ; Enable parse on save
(setq TeX-auto-local ".emacs.c/auto/") ; Directory for autosaves
(setq TeX-save-query nil) ;; autosave before compiling

(setq latex-run-command "pdflatex")
;; (load "preview-latex.el" nil t t)
(setq TeX-PDF-mode t) ;; set default to PDF-LaTeX
(setq-default TeX-master nil) ;; ask everytime for default master-file

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(*add-shell-paths* '("/usr/texbin"
		    "/usr/local/bin"
		    "/Library/TeX/texbin"
		    "/home/grads/tjtm88/bin"))

;; ========== font-latex =======================================================
;; (require 'font-latex)
;;
;; Hides ^ and _ in scripts.
;; (setq font-latex-fontify-script 'invisible)
;;

;; ========== texmf folder =====================================================

(defvar *path-texmf* (convert-standard-filename "~/texmf/")
  "Path to the local texmf folder.")
(when *system-darwin*
  (setq *path-texmf* (convert-standard-filename "~/Library/texmf/")))

;; ========== flycheck =========================================================

(require 'flycheck)
(setq flycheck-chktexrc (locate-user-emacs-file "config/lib/chktexrc"))

;; ========== flyspell =========================================================

(require 'flyspell)
(add-hook 'LaTeX-mode-hook 'flyspell-mode)
(add-hook 'LaTeX-mode-hook 'flyspell-buffer)

;; ========== Outline Mode =====================================================

(require 'outline)

(add-hook 'LaTeX-mode-hook 'outline-minor-mode)
(add-hook 'latex-mode-hook 'outline-minor-mode)

(setq outline-minor-mode-prefix "\C-c \C-o") ; Or something else
;;
;; ========== Latexmk ==========================================================
;;
;; Latexmk is a wonderful tool to organize compiling with latex. Among other
;; features is can simplify working with BibTeX, doing the necessary number of
;; compilations on its own. Options for Latexmk are being set by a configuration
;; file "config/lib/latexmkrc.conf".
;;
(defvar *path-latexmkrc* (locate-user-emacs-file "config/lib/latexmkrc")
  "Path to Latexmk setting file.")
;;
;; We will add a new TeX command for Latexmk. It outputs in emacs cache
;; directory and copies the PDF over when it is done. Helps keeping stuff
;; organised.
;;
(add-hook
 'LaTeX-mode-hook
 (lambda ()
   (add-to-list
    'TeX-command-list
    `("Latexmk"
      ,(concat "latexmk -pdf -bibtex -r " *path-latexmkrc* " %s && "
	       "rsync -cv .emacs.c/latexmk/%s.pdf ./ && "
	       "/Applications/Skim.app/Contents/SharedSupport/displayline"
	       " -r -g %n .emacs.c/latexmk/%o %b")
      TeX-run-TeX nil t :help "Run Latexmk"))))
;;
;; We then proceed to make it the default option.
;;
(add-hook 'TeX-mode-hook '(lambda () (setq TeX-command-default "Latexmk")))
;;
;; Use Skim as viewer, enable source <-> PDF sync
;; make latexmk available via C-c C-c
;; Note: SyncTeX is setup via ~/.latexmkrc (see below)
;;
;; ========== SyncTeX ==========================================================
;;
;; SyncTeX creates a map between (La)TeX and PDF files, which can be utilized by
;; the editors and viewers for communication. Latexmk is configured to use SyncTeX
;; in the configuration file, hence generating the map. Here we setup the
;; communication.
;;
;; On OSX (Skim):
(when *system-darwin*
  (setq TeX-view-program-selection '((output-pdf "Skim")))
  (setq TeX-view-program-list
	'(("Skim"
	   "/Applications/Skim.app/Contents/SharedSupport/displayline -r %n .emacs.c/latexmk/%o %b"))))
;; Skim's displayline is used for forward search (from .tex to .pdf).
;; Option -b highlights the current line; option -g opens Skim in the background.
;;
;; On Linux:
;;
;; Need to write this!
;;
;; For emacs, we just set a mouse key binding to open PDF viewer. Note that
;; C-c C-v is still much faster.
;;
(add-hook 'LaTeX-mode-hook
          (lambda () (local-set-key (kbd "<S-s-mouse-1>") #'TeX-view)))
;;
;; (server-start); start emacs in server mode so that skim can talk to it
;;
;; ========== RefTeX ===========================================================
;;
(require 'reftex)
;;
(autoload 'reftex-mode "reftex" "RefTeX Minor Mode" t)
(autoload 'turn-on-reftex "reftex" "RefTeX Minor Mode" nil)
(autoload 'reftex-citation "reftex-cite" "Make citation" nil)
(autoload 'reftex-index-phrase-mode "reftex-index" "Phrase Mode" t)
(add-hook 'latex-mode-hook 'turn-on-reftex) ; with Emacs latex mode
;; (add-hook 'reftex-load-hook 'imenu-add-menubar-index)
(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

(defun reftex-format-cref (label def-fmt ref-style)
  "Format as \cref{LABEL}.  DEF-FMT and REF-STYLE are ignored at the moment."
  (format "\\cref{%s}" label))

(setq reftex-format-ref-function 'reftex-format-cref)

(setq LaTeX-eqnarray-label "eq"
      LaTeX-equation-label "eq"
      LaTeX-figure-label "fig"
      LaTeX-table-label "tab"
      TeX-newline-function 'reindent-then-newline-and-indent
      LaTeX-section-hook
      '(LaTeX-section-heading
	LaTeX-section-title
	LaTeX-section-toc
	LaTeX-section-section
	LaTeX-section-label))

(setq reftex-insert-label-flags '("sft" "sfte"))

(add-to-list 'reftex-default-bibliography
	     (concat *path-texmf*
		     (convert-standard-filename "bibtex/bib/ajtex.bib")))

;; So that RefTeX also recognizes \addbibresource. Note that you
;; can't use $HOME in path for \addbibresource but that "~"
;; works.
(setq reftex-bibliography-commands
      '("bibliography" "nobibliography" "addbibresource"))
(setq reftex-extra-bindings t)


;; ========== mySpires Library =================================================
;;
;; mySpires is an online reference management system which allows you to "save"
;; papers on the fly while browsing the internet. It keeps an updated copy of
;; the corresponding BibTeX file in the Dropbox. We are going to integrate it in
;; our LaTeX environment.
;;
;; Path to mySpires bib file:
(defvar *path-mySpires-bib*
  (concat *path-dropbox*
	  (convert-standard-filename "Apps/mySpires/bib/mySpires_ajain.bib"))
  "Path to the original mySpires bibtex file.")
;;
;; Path to the local texmf copy of mySpires bib file:
(defvar *path-texmf-mySpires-bib*
  (concat *path-texmf*
	  (convert-standard-filename "bibtex/bib/mySpires_ajain.bib"))
  "Path to the texmf copy of mySpires bibtex file.")
;;
;; It is important that the original file is copied over to the texmf folder on
;; before it is being used. So we do it on every explicit save.
;;
(add-hook 'LaTeX-mode-hook
	  (lambda() (add-hook
		     'before-save-hook
		     (lambda() (copy-file *path-mySpires-bib*
					  *path-texmf-mySpires-bib* t t)))))
;;
;; We will also add this to the list of default RefTeX bibliographies.
;;
(add-to-list 'reftex-default-bibliography *path-mySpires-bib*)
;;
;; ========== LaTeX Preview ====================================================
;;
;; AucTeX can support real time previews, right in the buffer. Depends on your
;; taste.
;;
(require 'preview)
;;
(setq preview-auto-cache-preamble t) ;; Cache preamble for previews
;;
(eval-after-load "preview"
  '(add-to-list 'preview-default-preamble "\\PreviewEnvironment{tikzpicture}" t)
  )
;;
;; ========== Math Mode ========================================================

(require 'texmathp)
(add-to-list 'texmathp-tex-commands '("\\bee" arg-on))
(add-to-list 'texmathp-tex-commands '("\\bea" arg-on))
(texmathp-compile)

(eval-after-load "latex"
  '(progn
     (defun LaTeX-label (env))))

;; ========== Provide Library ==================================================

(provide 'config/auctex)


;;; auctex.el ends here
