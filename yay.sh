source common.sh

git clone https://aur.archlinux.org/yay.git

(
    cd yay;
    makepkg PKGBUILD;
    makepkg --clean --install --syncdeps;
)

rm -rf yay

yay
yay -S $EXTRA_PACKAGES_YAY