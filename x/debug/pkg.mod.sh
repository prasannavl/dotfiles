vars() { echo vars; }
check_install() { echo check_install; false; }

pre_install() { echo pre_install; true; }
install() { echo install; true; }
post_install() { echo post_install; true; }

pre_uninstall() { echo pre_uninstall; true; }
uninstall() { echo uninstall; true; }
post_uninstall() { echo post_uninstall; true; }

pre_link() { echo pre_link; true; }
post_link() { echo post_link; true; }

pre_unlink() { echo pre_unlink; true; }
post_unlink() { echo post_unlink; true; }

clean_conf() { echo clean_conf; true; }
clean() { echo clean; true; }
purge() { echo purge; true; }
