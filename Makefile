install:
	cp .zshrc ~/
	cp .emacs ~/
	cp -r .emacs.d ~/
	cp .zshort ~/
	cp .zcompletion ~/
	cp .gitconfig  ~/
	cp .gittemplate ~/
	cp -r .zsh ~/
	cp .vimrc ~/
	cp .profile ~/
	cp .psqlrc ~/
	sudo cp .zshrc /root
	sudo cp .emacs /root
	sudo cp -r .emacs.d /root
	sudo cp .zshort /root
	sudo cp .zcompletion /root
	sudo cp .gitconfig /root
	sudo cp .gittemplate /root
	sudo cp -r .zsh /root
	sudo cp .vimrc /root
	sudo cp .profile /root
	sudo cp .psqlrc /root

bash-install:
	cp .bashrc ~/
	cp .bash_aliases ~/
	cp .emacs ~/
	cp -r .emacs.d ~/
	cp .gitconfig  ~/
	cp .gittemplate ~/
	cp .vimrc ~/
	cp .profile ~/
	cp .psqlrc
	sudo cp .bashrc /root
	sudo cp .emacs /root
	sudo cp -r .emacs.d /root
	sudo cp .bash_aliases /root
	sudo cp .gitconfig  /root
	sudo cp .gittemplate /root
	sudo cp .vimrc /root
	sudo cp .profile /root
	sudo cp .psqlrc /root


