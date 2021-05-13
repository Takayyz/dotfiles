# dotfiles
## Requirements
- macOS

## Installation
You need install command line tools first.
```sh
$ xcode-select --install
```

### Via https
```sh
$ git clone https://github.com/Takayyz/dotfiles.git && cd dotfiles && ./setup.sh
```

### Via ssh
```sh
$ git clone git@github.com:Takayyz/dotfiles.git && cd dotfiles && ./setup.sh
```

## Note
- If you wanna change the color of branch name, then edit below
```
# /path/to/.zprezto/modules/prompt/functions/prompt_pure_setup
git_color=046 # you can choose the color you like
```

