# Vim on windows 

## With Syntax Highlighting for Powershell
This is a simple method for syntax highlighting without the bloat of modules or plugins etc:

Install vim:

```powershell
choco install vim -y
```

Download syntax highlighting file from:

```
wget https://raw.githubusercontent.com/PProvost/vim-ps1/master/syntax/ps1.vim
```

Then copy it to "C:\Program Files (x86)\vim\vim80\syntax" (or equivalent) using admin privs
Enable it in the ~\_vimrc:

```conf
autocmd BufRead,BufNewFile *.ps1 set filetype=ps1
syntax on
```


