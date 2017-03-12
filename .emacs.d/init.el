;;; init.el --- Spacemacs Initialization File
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize)

;; Increase gc-cons-threshold, depending on your system you may set it back to a
;; lower value in your dotfile (function `dotspacemacs/user-config')
(setq gc-cons-threshold 100000000)

(setq color0  "#000000"
      color1  "#CC0000"
      color2  "#4E9A06"
      color3  "#C4A000"
      color4  "#3465A4"
      color5  "#75507B"
      color6  "#06989A"
      color7  "#D3D7CF"
      color8  "#555753"
      color9  "#ef2929"
      color10 "#8ae234"
      color11 "#fce94f"
      color12 "#729fcf"
      color13 "#ad7fa8"
      color14 "#34e2e2"
      color15 "#eeeeec")

(setq ansi-color-black        color0
      ansi-color-bold-black   color8
      ansi-color-red          color1
      ansi-color-bold-red     color9
      ansi-color-green        color2
      ansi-color-bold-green   color10
      ansi-color-yellow       color3
      ansi-color-bold-yellow  color11
      ansi-color-blue         color4
      ansi-color-bold-blue    color12
      ansi-color-magenta      color5
      ansi-color-bold-magenta color13
      ansi-color-cyan         color6
      ansi-color-bold-cyan    color14
      ansi-color-white        color7
      ansi-color-bold-white   color15)

(setq ansi-color-names-vector
      (vector ansi-color-black
              ansi-color-red
              ansi-color-green
              ansi-color-yellow
              ansi-color-blue
              ansi-color-magenta
              ansi-color-cyan
              ansi-color-white))

(setq ansi-color-bold-colors
      `((,ansi-color-black   . ,ansi-color-bold-black  )
        (,ansi-color-red     . ,ansi-color-bold-red    )
        (,ansi-color-green   . ,ansi-color-bold-green  )
        (,ansi-color-yellow  . ,ansi-color-bold-yellow )
        (,ansi-color-blue    . ,ansi-color-bold-blue   )
        (,ansi-color-magenta . ,ansi-color-bold-magenta)
        (,ansi-color-cyan    . ,ansi-color-bold-cyan   )
        (,ansi-color-white   . ,ansi-color-bold-white  )))

(defun ansi-color-get-bold-color (color)
  (or (cdr (assoc color ansi-color-bold-colors))
      color))

(defun ansi-color-boldify-face (face)
  (if (consp face)
      (let* ((property   (car face))
             (color      (cdr face))
             (bold-color (ansi-color-get-bold-color color)))
        (ansi-color-make-face property bold-color))
    face))

(eval-after-load "ansi-color"
  '(progn
     ;; Copied from `ansi-color.el' and modified to display
     ;; bold faces using slighly different, brigher colors.
     (defun ansi-color-get-face (escape-seq)
       (let ((i 0)
             f val)
         (while (string-match ansi-color-parameter-regexp
                              escape-seq i)
           (setq i   (match-end 0)
                 val (ansi-color-get-face-1
                      (string-to-number
                       (match-string 1 escape-seq) 10)))
           (cond ((not val))
                 ((eq val 'default)
                  (setq f (list val)))
                 (t
                  (unless (member val f)
                    (push val f)))))
         ;; Use brighter colors for bold faces.
         (when (member 'bold f)
           (setq f (mapcar 'ansi-color-boldify-face f)))
         f))
     ;; Copied from `ansi-color.el' and modified to support
     ;; so called high intensity colors.
     (defun ansi-color-make-color-map ()
       (let ((ansi-color-map (make-vector 110 nil))
             (index 0))
         ;; miscellaneous attributes
         (mapc
          (function (lambda (e)
                      (aset ansi-color-map index e)
                      (setq index (1+ index)) ))
          ansi-color-faces-vector)
         ;; foreground attributes
         (setq index 30)
         (mapc
          (function
           (lambda (e)
             (aset ansi-color-map index
                   (ansi-color-make-face 'foreground e))
             (setq index (1+ index)) ))
          ansi-color-names-vector)
         ;; background attributes
         (setq index 40)
         (mapc
          (function
           (lambda (e)
             (aset ansi-color-map index
                   (ansi-color-make-face 'background e))
             (setq index (1+ index)) ))
          ansi-color-names-vector)
         ;; foreground attributes -- high intensity
         (setq index 90)
         (mapc
          (function
           (lambda (e)
             (aset ansi-color-map index
                   (ansi-color-make-face 'foreground e))
             (setq index (1+ index)) ))
          ansi-color-names-vector)
         ;; background attributes -- high intensity
         (setq index 100)
         (mapc
          (function
           (lambda (e)
             (aset ansi-color-map index
                   (ansi-color-make-face 'background e))
             (setq index (1+ index)) ))
          ansi-color-names-vector)
         ansi-color-map))))

(defun ansi-color-generate-color-map ()
(setq ansi-color-map (ansi-color-make-color-map)))

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(add-hook 'shell-mode-hook 'ansi-color-generate-color-map)

(defconst spacemacs-version          "0.200.7" "Spacemacs version.")
(defconst spacemacs-emacs-min-version   "24.4" "Minimal version of Emacs.")

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (message (concat "Your version of Emacs (%s) is too old. "
                     "Spacemacs requires Emacs version %s or above.")
             emacs-version spacemacs-emacs-min-version)
  (load-file (concat (file-name-directory load-file-name)
                     "core/core-load-paths.el"))

  (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

  (require 'core-spacemacs)
  (spacemacs/init)
  (spacemacs/maybe-install-dotfile)
  (configuration-layer/sync)
  (spacemacs-buffer/display-info-box)
  (spacemacs/setup-startup-hook)
  (require 'server)
  (unless (server-running-p) (server-start)))
