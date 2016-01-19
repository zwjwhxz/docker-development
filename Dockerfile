FROM base/archlinux:latest
ENV VNUM 1.00003

#Make sure keys are fresh
RUN pacman -Sc
RUN pacman-key --populate archlinux
RUN pacman-key --refresh-keys

#Update
RUN pacman -Syyu --noconfirm
RUN pacman-db-upgrade

#Install basic net tools
RUN pacman -S wget --noconfirm

#Install C/C++/Fortran Development Tools
RUN pacman -S gcc gcc-fortran astyle cmake automake make clang boost pkg-config gtest htop lldb perf cloc --noconfirm

#Install basic python development tools
RUN pacman -S python-pip python2-pip  --noconfirm
RUN pip install flake8 && pip2 install flake8

#Install basic python libraries
RUN pacman -S postgresql-libs --noconfirm
RUN pip install psycopg2

#Install Golang
RUN pacman -S go --noconfirm
ENV PATH $PATH:/root/workdir/go/bin
ENV GOPATH /root/workdir/go
VOLUME /root/workdir

#Install version control
RUN pacman -S git mercurial --noconfirm

#Install vim
WORKDIR /root
RUN pacman -S vim --noconfirm

#Pull vimrc
RUN wget https://raw.githubusercontent.com/iamthebot/docker-development/master/.vimrc
#vim pathogen
RUN mkdir -p /root/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
#vim cobalt color scheme
RUN mkdir -p /root/.vim/colors && curl -LSso /root/.vim/colors/cobalt.vim https://raw.githubusercontent.com/sfsekaran/cobalt.vim/master/colors/cobalt.vim 
#vim cobaltish color scheme
RUN mkdir -p /root/.vim/colors && curl -LSso /root/.vim/colors/cobaltish.vim https://raw.githubusercontent.com/flazz/vim-colorschemes/master/colors/cobaltish.vim

#install nerdtree vim file explorer
RUN mkdir -p /root/.vim/bundle
RUN git clone https://github.com/scrooloose/nerdtree.git /root/.vim/bundle/nerdtree
#install vim airline
RUN git clone https://github.com/bling/vim-airline.git /root/.vim/bundle/vim-airline
#install vim YouCompleteMe
RUN git clone https://github.com/Valloric/YouCompleteMe.git /root/.vim/bundle/YouCompleteMe
WORKDIR /root/.vim/bundle/YouCompleteMe
RUN git submodule update --init --recursive
RUN ./install.sh --clang-completer --system-libclang --system-boost --gocode-completer
WORKDIR /
#install vim Autoformat
RUN git clone https://github.com/Chiel92/vim-autoformat.git /root/.vim/bundle/vim-autoformat
#install vim Fugitive
RUN git clone https://github.com/tpope/vim-fugitive.git /root/.vim/bundle/vim-fugitive
#install vim gitgutter
RUN git clone https://github.com/airblade/vim-gitgutter.git /root/.vim/bundle/vim-gitgutter
#install vim-go
RUN git clone https://github.com/fatih/vim-go.git /root/.vim/bundle/vim-go
#install tagbar
RUN git clone https://github.com/majutsushi/tagbar.git /root/.vim/bundle/tagbar

#install ssh
RUN pacman -S openssh --noconfirm
RUN echo "alias ls='ls --color'" >> /root/.bashrc
