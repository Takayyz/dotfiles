# dotfiles

[![total lines](https://aschey.tech/tokei/github/Takayyz/dotfiles)](https://github.com/XAMPPRocky/tokei)
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

## tmux キーバインド (カスタム)

prefix は `C-a` に変更済み。

| キー | 説明 |
|------|------|
| `C-h/j/k/l` | Neovim / tmux ペイン間をシームレスに移動 (vim-tmux-navigator) |
| `C-g` | lazygit をポップアップで開く |
| `C-n` | navi (チートシート) をポップアップで開く |
| `M-z` | ペインのズーム切替 |
| `prefix + x` | ペインを閉じる |
| `prefix + c` | 新規ウィンドウ |
| `prefix + %` / `"` | ペイン分割 (横/縦) |
| `prefix + w` | worktree switcher |
| `prefix + f` | yazi (ファイルマネージャー) |
| `prefix + m` | btop (システムモニター) |
| `prefix + d` | Docker Compose status (Iceberg テーマで色付き表示、2秒ごと自動更新) |
| `M-f p` | ghq project switcher |

## Neovim キーバインド (カスタム)

Leader は `Space`。プラグイン管理は lazy.nvim。

### Picker (snacks.nvim)

| キー | 説明 |
|------|------|
| `<Leader>?` | Keymaps 一覧 |
| `<Leader><Space>` | Smart Find Files |
| `<Leader>,` | Buffers |
| `<Leader>/` | Grep |
| `<Leader>:` | Command History |
| `<Leader>ff` | Find Files |
| `<Leader>fg` | Find Git Files |
| `<Leader>fr` | Recent Files |
| `<Leader>fc` | Find Config File |
| `<Leader>gs` | Git Status |
| `<Leader>gl` | Git Log |
| `<Leader>gd` | Git Diff (Hunks) |
| `<Leader>sg` | Grep |
| `<Leader>sw` | Grep Word (normal/visual) |
| `<Leader>sh` | Help Pages |
| `<Leader>sk` | Keymaps |
| `<Leader>sd` | Diagnostics |
| `<Leader>sR` | Resume Last Picker |
| `<Leader>su` | Undo History |
| `gd` | LSP: Goto Definition |
| `gr` | LSP: References |
| `gI` | LSP: Goto Implementation |
| `gy` | LSP: Goto Type Definition |

### Toggle (snacks.nvim)

| キー | 説明 |
|------|------|
| `<Leader>us` | Toggle Spelling |
| `<Leader>uw` | Toggle Wrap |
| `<Leader>ul` | Toggle Line Numbers |
| `<Leader>uL` | Toggle Relative Numbers |
| `<Leader>ud` | Toggle Diagnostics |
| `<Leader>uh` | Toggle Inlay Hints |
| `<Leader>ug` | Toggle Indent Guides |
| `<Leader>uT` | Toggle Treesitter |
| `<Leader>uc` | Toggle Conceal |
| `<Leader>ub` | Toggle Dark/Light Background |

### Treesitter (nvim-treesitter)

コード編集全般の AST ベースシンタックスハイライト・インデントを提供。noice.nvim のコマンドラインハイライトにも利用される。

- `ensure_installed`: noice.nvim 推奨パーサー + 作業言語 (TypeScript, PHP 等)
- `auto_install`: 未インストールの言語を開くと自動でパーサーをインストール
- 100KB 以上のファイルではハイライトを自動で無効化 (パフォーマンス保護)

#### Textobjects (nvim-treesitter-textobjects)

**Select** — オペレータ (`d`, `c`, `y`, `v`) と組み合わせて使用:

| テキストオブジェクト | 対象 |
|---------------------|------|
| `af` / `if` | 関数 (outer/inner) |
| `ac` / `ic` | クラス (outer/inner) |
| `aa` / `ia` | 引数・パラメータ (outer/inner) |
| `al` / `il` | ループ (outer/inner) |

**Move** — 関数/クラス間ジャンプ:

| キー | 説明 |
|------|------|
| `]m` / `[m` | 次/前の関数の先頭 |
| `]M` / `[M` | 次/前の関数の末尾 |
| `]]` / `[[` | 次/前のクラスの先頭 |

**Swap** — 引数の入れ替え:

| キー | 説明 |
|------|------|
| `<Leader>a` | 引数を次と入れ替え |
| `<Leader>A` | 引数を前と入れ替え |

### Noice (noice.nvim)

| キー | 説明 |
|------|------|
| `<S-Enter>` | コマンドライン出力をリダイレクト (cmdline モード) |
| `<Leader>snl` | 最後のメッセージを表示 |
| `<Leader>snh` | メッセージ履歴 |
| `<Leader>sna` | 全メッセージ |
| `<Leader>snd` | 通知をすべて消す |

## 参考記事
- [defaultsコマンド](http://neos21.hatenablog.com/entry/2019/01/10/080000)
- [defauls一覧](https://github.com/ulwlu/dotfiles/blob/master/system/macos.sh)
- [setup.shまとめ](https://qiita.com/kai_kou/items/af5d0c81facc1317d836)
- [環境構築系記事](https://qiita.com/kai_kou/items/3107e0a056c7a1b569cd)
- [Gistについて](https://qiita.com/hkusu/items/18cbe582abb9d3172019)
