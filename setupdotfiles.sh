git init --bare /home/martian/.cfg
alias config='/usr/bin/git --git-dir=/home/martian/.cfg/ --work-tree=/home/martian'
config config --local status.showUntrackedFiles no
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.bashrc
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'" >> $HOME/.zshrc
