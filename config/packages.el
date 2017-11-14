;;; config/packages.el --- Package manager
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
;; This file manages packages which this configuration needs.
;; If the packages are missing, it attempts to install them.
;;

;;; Code:

(require 'package)

;; ========== Repositories ========================================================

(push '("marmalade" . "https://marmalade-repo.org/packages/")
      package-archives)
(push '("melpa" . "https://melpa.org/packages/")
      package-archives)

(when (not package-archive-contents)
  (package-refresh-contents))

;; ========== Packages ============================================================

(defvar aj-packages
  '(
    better-defaults ;; Better default behaviour for emacs.
    flycheck        ;; Checks for syntax errors on the fly. Better than flymake.
    elpy            ;; The package for python support.
    py-autopep8     ;; Autopep8 standard for Python.
    php-mode
    web-mode
    sass-mode
;;    tabbar          ;; If tabs are your thing.
    ))

;; ========== Auto-Installer ======================================================

(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      aj-packages)

;; ========== Provide Library =====================================================

(provide 'config/packages)


;;; packages.el ends here
