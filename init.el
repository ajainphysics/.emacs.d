;;; init.el --- Emacs configuration
;;
;; Copyright (C) Akash Jain
;;
;; Author: Akash Jain <ajainphysx@gmail.com>
;; Keywords: .emacs, init.el
;; Homepage: https://ajainphysics.com
;;
;; This file is part of an emacs configuration.
;;

;;; Commentary:
;;
;; This file contains customisation for an Emacs distribution.  It has many
;; dependencies, which should be checked below.
;;

;;; Code:

;; ========== Basic Configuration ==============================================

(package-initialize)

(message "akash")

;; We first include our custom functions and variables.
(require 'config/definitions (locate-user-emacs-file "config/definitions.el"))

; Directory for backups .
(setq backup-directory-alist `((".*" . ".emacs.c/backups")))
(setq auto-save-file-name-transforms `(("\\([^/]*\\)$" ".emacs.c/backups/\\1")))

(*config* 'frame)    ;; Basic behaviour and look settings for Emacs.
(*config* 'packages) ;; Define package libraries and install missing packages.
(*config* 'ido)      ;; A nice way to switch buffers and look for files.

;; ========== flyspell =========================================================

(require 'flyspell)

(setenv "DICTIONARY" "en_GB")

(eval-after-load "flyspell"
  '(progn
     (define-key flyspell-mouse-map [down-mouse-3] #'flyspell-correct-word)
     (define-key flyspell-mouse-map [mouse-3] #'undefined)))

(setq ispell-program-name "aspell") ; Engine for spellcheck. Could be ispell
				    ; (more basic).
(setq ispell-dictionary "en_GB") ; The language you want to support.
(setq ispell-personal-dictionary (locate-user-emacs-file "dictionaries/en.pws"))

;; Will use ispell-local-dictionary-list
;;(setq ispell-extra-args
;;      '("--run-together" "--run-together-limit=5" "--run-together-min=2"))

(add-hook 'emacs-lisp-mode-hook 'flyspell-prog-mode)

(require 'langtool)
(setq langtool-language-tool-jar "~/Packages/LanguageTool-3.9/languagetool-commandline.jar")

;; ========== flycheck =========================================================

(add-hook 'after-init-hook #'global-flycheck-mode) ;; Turn on flycheck globally.

;; ========== Mode Options =====================================================

(*config* 'auctex) ;; LaTeX configuration.
(*config* 'web)    ;; HTML, CSS, JavaScript, PHP, MySQL configuration.
(*config* 'python) ;; Python configuration.
(*config* 'python) ;;

(add-to-list 'custom-theme-load-path
	     (concat user-emacs-directory (convert-standard-filename "themes")))

;; ========== Emacs Customizations =============================================

;; Automatic customizations will not pollute the init.el file.
;; The will get saved in "config/customizations.el" file instead.
(setq custom-file
      (concat user-emacs-directory (convert-standard-filename "config/customizations.el")))
(load custom-file)

;; If you have some unsaved customizations, you will be prompted to save them.
(add-hook 'kill-emacs-query-functions
	  'custom-prompt-customize-unsaved-options)

;;; init.el ends here
