;;; config/definitions.el --- Configurations for LaTeX
;;
;; Copyright (C) Akash Jain
;;
;; Author: Akash Jain <ajainphysx@gmail.com>
;; Keywords: definitions, user defined functions
;; Homepage: https://ajainphysics.com
;;
;; This file is part of an emacs configuration.
;;

;;; Commentary:
;;
;; This file contains many useful definitions and functions.
;;

;;; Code:

;; ========== Functions ========================================================

;; Provides a shortcut to declare configuration files.
(defun *config*(lib)
  "Tell Emacs to require a user configuration file."
  (require (intern (concat "config/" (symbol-name lib)))
	   (concat user-emacs-directory
		   (convert-standard-filename
		    (concat "config/" (symbol-name lib) ".el")))))

(defun *add-shell-paths*(pathlist)
  "Add a list of paths to the shell"
  (progn
    (mapc #'(lambda (path)
	      (setenv "PATH" (concat path ":" (getenv "PATH"))))
	  pathlist)
    (setq exec-path (append pathlist exec-path))
    ))

;; ========== Check system =====================================================

(defconst *system-darwin* (string-equal system-type "darwin"))
(defconst *system-gnu* (string-equal system-type "gnu/linux"))
(defconst *system-windows* (string-equal system-type "windows-nt"))

;; ========== Dropbox ==========================================================

(defvar *path-dropbox* (convert-standard-filename "~/Dropbox/")
  "Path to the local Dropbox folder.")
(when *system-darwin*
  (setq *path-dropbox* (convert-standard-filename "~/Dropbox/")))


(require 'server)

(defun *server-start* (name)
  "Start a custom Emacs server named NAME."

  (unless (server-running-p name)
    (setq server-name name)
    (server-start)
    (setq frame-title-format '("" "%b (" server-name ")")))
  )

;; ========== Provide Library ==================================================

(provide 'config/definitions)


;;; definitions.el ends here
