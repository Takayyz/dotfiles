# dotfiles
## Requirements
- macOS

## Installation
You need install command line tools before 
```sh
$ xcode-select --install
```

```sh
# https
$ git clone https://github.com/Takayyz/dotfiles.git && cd dotfiles && chmod 744 ./setup.sh && ./setup.sh

# ssh
$ git clone git@github.com:Takayyz/dotfiles.git && cd dotfiles && chmod 744 ./setup.sh && ./setup.sh
```

## Note
- If you wanna change the color of branch name, then edir below
```
# /path/to/.zprezto/modules/prompt/functions/prompt_pure_setup
git_color=046 # you can choose the color you like
```

