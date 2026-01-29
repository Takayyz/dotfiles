# dotfiles

[![total lines](https://tokei.ekzhang.com/b1/github/Takayyz/dotfiles)](https://github.com/XAMPPRocky/tokei)
![GitHub code size in bytes](https://img.shields.io/github/languages/code-size/Takayyz/dotfiles)
![GitHub repo size](https://img.shields.io/github/repo-size/Takayyz/dotfiles)

![macos](https://github.com/Takayyz/dotfiles/workflows/macos/badge.svg)

## Requirements
- macOS

### Via https
```sh
git clone https://github.com/Takayyz/dotfiles.git && cd dotfiles && make all
```

### Via ssh
```sh
git clone git@github.com:Takayyz/dotfiles.git && cd dotfiles && make all
```

## Volta (.Voltafile)

Node.js のランタイム・パッケージマネージャー・グローバルパッケージを Brewfile と同様の形式で宣言的に管理します。

```sh
# 個別実行
make volta

# .Voltafile にパッケージを追加した後に再実行すれば差分インストールされます
```

`.config/.Voltafile` の記法:
```
runtime "node" "24.11.1"       # バージョン固定
manager "pnpm" "10.21.0"       # バージョン固定
package "@anthropic-ai/claude-code"  # 最新バージョン
```

## 参考記事
- [defaultsコマンド](http://neos21.hatenablog.com/entry/2019/01/10/080000)
- [defauls一覧](https://github.com/ulwlu/dotfiles/blob/master/system/macos.sh)
- [setup.shまとめ](https://qiita.com/kai_kou/items/af5d0c81facc1317d836)
- [環境構築系記事](https://qiita.com/kai_kou/items/3107e0a056c7a1b569cd)
- [Gistについて](https://qiita.com/hkusu/items/18cbe582abb9d3172019)
