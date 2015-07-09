FROM base/archlinux:latest

#Make sure keys are fresh
RUN pacman-key --populate archlinux
RUN pacman-key --refresh-keys

#Update
RUN pacman -Syyu --noconfirm
RUN pacman-db-upgrade

#Create shared home dir
RUN mkdir -p /root/share

#Install C/C++/Fortran Development Tools
RUN pacman -S gcc gcc-fortran astyle cmake automake make clang boost --noconfirm

#Install basic python development tools
RUN pacman -S python-pip python2-pip  --noconfirm
RUN pip install flake8 && pip2 install flake8

#Install basic python libraries
RUN pip install psycopg2

#Install Golang
RUN pacman -S go --noconfirm
RUN mkdir -p /root/go/src mkdir -p /root/go/bin
ENV PATH $PATH:/root/go/bin
ENV GOPATH /root/go

#Install version control
RUN pacman -S git mercurial --noconfirm

#Install vim
WORKDIR /root

#Pull vimrc
RUN wget https://raw.githubusercontent.com/iamthebot/docker-development/master/.vimrc
#vim pathogen
RUN mkdir -p /root/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.v
#install nerdtree vim file explorer
RUN mkdir -p /root/.vim/bundle
RUN git clone https://github.com/scrooloose/nerdtree.git /root/.vim/bundle/nerdtree
#install vim syntastic
RUN git clone https://github.com/scrooloose/syntastic.git /root/.vim/bundle/syntastic
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
