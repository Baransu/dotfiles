 (when (configuration-layer/layer-usedp 'prettier)
  (setq prettier-target-mode "react-mode")
  (setq prettier-command "prettier")
  (setq prettier-args '("--single-quote" "--trailing-comma"))

  (load-file "~/.emacs.d/layers/+tools/prettier/prettier-js.el")
  (require 'prettier-js)

  (add-hook 'react-mode-hook
            (lambda ()
              (add-hook 'before-save-hook 'prettier-before-save))))
