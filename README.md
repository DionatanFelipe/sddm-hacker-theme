# # SDDM Hacker Fork Theme

Este é um tema SDDM estilo hacker com fundo escuro, texto verde neon e efeito de chuva digital da Matrix.

# SDDM Hacker Fork Theme
This is a hacker-style SDDM theme with a dark background, neon green text, and a Matrix digital rain effect.

# SDDM Hacker Fork Theme
Este es un tema SDDM estilo hacker con fondo oscuro, texto verde neón y efecto de lluvia digital de Matrix.

## 
![Preview](screenshot.png)


## Installation :

```bash
sudo cp -r ~/Downloads/sddm-hacker-theme-main /usr/share/sddm/themes/
```


## Notes
- The matrix effect is lightweight but can be disabled by removing the `Canvas` and `Timer` components in `Main.qml` if performance is an issue.
- For a more advanced setup (with video in the background), you can replace `Main.qml` with `Main.qml.Video` and make sure it name is `Main.qml`
