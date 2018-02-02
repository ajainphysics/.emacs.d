;;; config/frame.el --- Basic configevuration for emacs frames
;;
;; Copyright (C) Akash Jain
;;
;; Author: Akash Jain <ajainphysx@gmail.com>
;; Keywords: latex, auctex, emacs
;; Homepage: https://ajainphysics.com
;;
;; This file is part of an emacs configuration.
;;

;;; Commentary:
;;
;; This file contains basic customizations for macs frames.
;;

;;; Code:

;; (print (/ (* (window-total-width) (display-pixel-width)) (window-pixel-width)))

(setq initial-frame-alist '((width . 90) (height . 50)))
(setq default-frame-alist '((width . 90) (height . 50)))

(global-linum-mode t) ; Enable line numbers everywhere
(setq-default fill-column 80) ; Line break point
(add-hook 'text-mode-hook 'turn-on-auto-fill) ; Automatic alignment

;; (menu-bar-mode -1) ;; Disable menu-bar
;; (toggle-scroll-bar -1) ;; Disable scroll-bar
(tool-bar-mode -1) ;; Disable tool-bar

(delete-selection-mode 1) ;; Selection overwrite

;; Font Size
;;(when (system-type-is-darwin)
;;  (set-face-attribute 'default nil :height 150))

(setq-default cursor-type 'bar) ;; Changes the curson from a square to a bar.

(setq inhibit-startup-message t) ;; hide the startup message
;;
;; ========== Bells and Errors =================================================
;;
;; Bell is that beep which happens on errors. This code is to make it less
;; intrusive and annoyting. First of all we disable the bell.
;;
(setq ring-bell-function 'ignore)
;;
;; We will later associate it to a mode line flash.
;;
(defun *mode-line-flash* ()
  "Flash the mode line."
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil 'invert-face 'mode-line))
;;
;; We define 3 special list of errors. Each entry in these lists must be a pair
;; (error caller). You can use (t caller) or (error t) if you want to specify
;; all errors from a caller or an error from all callers respectively.
;;
;; Errors which should be ignored altogether:
(defvar *command-errors-ignore-alist*
  '(
    (beginning-of-buffer mwheel-scroll) ;; Top of buffer with scroll.
    (end-of-buffer mwheel-scroll) ;; Bottom of buffer with scroll.
    )
  "Distracting errors to be ignored.")
;;
;; Errors which should only be flashed:
(defvar *command-errors-flash-alist*
  '(
    (text-read-only t) ;; Text is read only.
    (buffer-read-only t) ;; Buffer is read only.
    )
  "Errors to only be flashed and not prompted.")
;;
;; Errors which should only be prompted:
(defvar *command-errors-prompt-alist*
  '(
    (quit nil) ;; Quitting from things.
    )
  "Errors to only be prompted and not flashed.")
;;
;; Note that ignore list takes precedence over the other two. It means that if
;; an error matches the ignore list as well as another list, it will be ignored.
;;
;; Now the following handler deals with these error lists.
;;
(defun *command-error-function-ignorant* (data context caller)
  "Less intrusive version of the handler (command-error-default-function DATA CONTEXT CALLER)."
  (unless (or
	   (member `(,(car data) t) *command-errors-ignore-alist*)
	   (member `(t ,caller) *command-errors-ignore-alist*)
	   (member `(,(car data) ,caller) *command-errors-ignore-alist*))

    (unless (or
	   (member `(,(car data) t) *command-errors-flash-alist*)
	   (member `(t ,caller) *command-errors-flash-alist*)
	   (member `(,(car data) ,caller) *command-errors-flash-alist*))
      (command-error-default-function data context caller))

    (unless (or
	   (member `(,(car data) t) *command-errors-prompt-alist*)
	   (member `(t ,caller) *command-errors-prompt-alist*)
	   (member `(,(car data) ,caller) *command-errors-prompt-alist*))
      (*mode-line-flash*))))
;;
;; We replace the original handler with this new handler.
;;
(setq command-error-function #'*command-error-function-ignorant*)
;;
;; ========== Scrolling ========================================================
;;
;; While using touchpad, inadvertant left/right swipes cause errors as they are
;; not defined. So define them to be ignored.
;;
(global-set-key (kbd "<wheel-right>") 'ignore)
(global-set-key (kbd "<double-wheel-right>") 'ignore)
(global-set-key (kbd "<triple-wheel-right>") 'ignore)
(global-set-key (kbd "<wheel-left>") 'ignore)
(global-set-key (kbd "<double-wheel-left>") 'ignore)
(global-set-key (kbd "<triple-wheel-left>") 'ignore)
;;
;; scroll one line at a time (less "jumpy" than defaults)
;;
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
(setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
;; (setq scroll-step 1) ;; keyboard scroll one line at a time
;;
;; ========== Fill Column Mode =================================================
;;
;; (require 'fill-column-indicator)
;;
;; (add-hook 'after-change-major-mode-hook 'fci-mode)
;;
;; (setq fci-always-use-textual-rule t) ;; To use the character "|".
;; (setq fci-rule-use-dashes t)         ;; To use dashed line.
;; (setq fci-dash-pattern 0.75)         ;; Retio of dash.
;;
;; (setq fci-handle-truncate-lines nil)
;; (setq fci-handle-line-move-visual nil)
;;
;; ========== Restart Emacs ====================================================
;;
(require 'restart-emacs)
(setq restart-emacs-restore-frames t)
(global-set-key (kbd "C-c C-x C-c") #'restart-emacs)
;;
;; ========== Provide ==========================================================
;;
(provide 'config/frame)

;;; frame.el ends here
