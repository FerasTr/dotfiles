(setq user-full-name "Feras D")

(setq user-mail-address "daragma.feras@gmail.com")

(setq frame-resize-pixelwise t)

(after! all-the-icons
  (setq all-the-icons-scale-factor 1.0))

(setq eldoc-idle-delay 0)

(setq evil-split-window-below t
      evil-vsplit-window-right t)

(setq org-directory "~/Notes/"
      org-ellipsis " ▼ "
      org-superstar-headline-bullets-list '("☰" "☱" "☲" "☳" "☴" "☵" "☶" "☷" "☷" "☷" "☷")
      org-log-done 'time)
(require 'org-inlinetask)
(setq display-line-numbers-type 'relative)

(setq doom-theme 'doom-dracula)

(setq doom-font (font-spec :family "Fira Code" :size 18))
