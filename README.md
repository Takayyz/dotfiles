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

| キー               | 説明                                                                |
| ------------------ | ------------------------------------------------------------------- |
| `C-h/j/k/l`        | Neovim / tmux ペイン間をシームレスに移動 (vim-tmux-navigator)       |
| `prefix + g`       | lazygit をポップアップで開く                                        |
| `C-n`              | navi (チートシート) をポップアップで開く                            |
| `M-z`              | ペインのズーム切替                                                  |
| `prefix + x`       | ペインを閉じる                                                      |
| `prefix + c`       | 新規ウィンドウ                                                      |
| `prefix + \` / `-`  | ペイン分割 (横/縦)                                                  |
| `prefix + w`       | worktree switcher                                                   |
| `prefix + f`       | yazi (ファイルマネージャー)                                         |
| `prefix + m`       | btop (システムモニター)                                             |
| `prefix + d`       | Docker Compose status (Iceberg テーマで色付き表示、2秒ごと自動更新) |
| `M-f p`            | ghq project switcher                                                |

<details>
<summary>補助キー (コピーモード・ウィンドウ操作)</summary>

| キー | 説明 |
|---|---|
| `prefix + i` | ウィンドウを左に移動 |
| `prefix + o` | ウィンドウを右に移動 |
| `prefix + R` | ペインタイトルをリネーム |
| `prefix + [` → `v` | 選択開始 (copy-mode) |
| `prefix + [` → `V` | 行選択 (copy-mode) |
| `prefix + [` → `C-v` | 矩形選択トグル (copy-mode) |
| `prefix + [` → `y` / `Enter` | クリップボードにヤンク (copy-mode) |
| `prefix + [` → `[` / `]` | 前/次のプロンプトへ移動 (copy-mode) |

</details>

## Neovim キーバインド (カスタム)

Leader は `Space`。プラグイン管理は lazy.nvim。

### 基本操作 (keymaps.lua)

| キー | 説明 |
|---|---|
| `jj` (insert) | Escape |
| `<Leader>w` | Save |
| `<Leader>q` | Quit |
| `<Leader>h` / `<Leader>l` | 行頭 / 行末 |
| `<Leader>c` | コメントトグル (normal/visual) |
| `<Leader>yp` | Git ルートからの相対パスをクリップボードにコピー |
| `<Leader>-` / `<Leader>\` | 水平 / 垂直分割 |

<details>
<summary>補助キー (タブ・インデント等)</summary>

| キー | 説明 |
|---|---|
| `<S-Tab>` (insert) | デデント |
| `<Esc><Esc>` | 検索ハイライトクリア |
| `gg` | ファイル先頭の最初の文字へ |
| `<Leader><` / `<Leader>>` | デデント / インデント |
| `<Leader>n` | 新規ファイル |
| `<Leader>t` | 新規タブ |
| `<Leader><Tab>` / `<Leader><S-Tab>` | 次 / 前のタブ |

</details>

### Picker (snacks.nvim)

| キー              | 説明                      |
| ----------------- | ------------------------- |
| `<Leader>?`       | Keymaps 一覧              |
| `<Leader><Space>` | Smart Find Files          |
| `<Leader>,`       | Buffers                   |
| `<Leader>/`       | Grep                      |
| `<Leader>:`       | Command History           |
| `<Leader>ff`      | Find Files                |
| `<Leader>fg`      | Find Git Files            |
| `<Leader>fr`      | Recent Files              |
| `<Leader>fc`      | Find Config File          |
| `<Leader>gs`      | Git Status                |
| `<Leader>gl`      | Git Log                   |
| `<Leader>gd`      | Git Diff (Hunks)          |
| `<Leader>sg`      | Grep                      |
| `<Leader>sw`      | Grep Word (normal/visual) |
| `<Leader>sh`      | Help Pages                |
| `<Leader>sk`      | Keymaps                   |
| `<Leader>sd`      | Diagnostics               |
| `<Leader>sR`      | Resume Last Picker        |
| `<Leader>su`      | Undo History              |
| `gd`              | LSP: Goto Definition      |
| `gr`              | LSP: References           |
| `gI`              | LSP: Goto Implementation  |
| `gy`              | LSP: Goto Type Definition |

<details>
<summary>Find / Git / Search / LSP 補助キー</summary>

**Find (`<Leader>f`)**

| キー | 説明 |
|---|---|
| `<Leader>fb` | Buffers |

**Git (`<Leader>g`)**

| キー | 説明 |
|---|---|
| `<Leader>gb` | Git Branches |
| `<Leader>gL` | Git Log Line |
| `<Leader>gS` | Git Stash |
| `<Leader>gf` | Git Log File |

**Search (`<Leader>s`)**

| キー | 説明 |
|---|---|
| `<Leader>sb` | Buffer Lines |
| `<Leader>sB` | Grep Open Buffers |
| `<Leader>s"` | Registers |
| `<Leader>s/` | Search History |
| `<Leader>sa` | Autocmds |
| `<Leader>sc` | Command History |
| `<Leader>sC` | Commands |
| `<Leader>sD` | Buffer Diagnostics |
| `<Leader>sH` | Highlights |
| `<Leader>si` | Icons |
| `<Leader>sj` | Jumps |
| `<Leader>sl` | Location List |
| `<Leader>sm` | Marks |
| `<Leader>sM` | Man Pages |
| `<Leader>sp` | Search for Plugin Spec |
| `<Leader>sq` | Quickfix List |

**LSP**

| キー | 説明 |
|---|---|
| `gD` | Goto Declaration |
| `<Leader>j` | Goto Definition (alias) |
| `<Leader>r` | References (alias) |
| `<Leader>ss` | LSP Symbols |
| `<Leader>sS` | LSP Workspace Symbols |

**Other**

| キー | 説明 |
|---|---|
| `<Leader>uC` | Colorschemes |

</details>

### Toggle (snacks.nvim)

| キー         | 説明                         |
| ------------ | ---------------------------- |
| `<Leader>us` | Toggle Spelling              |
| `<Leader>uw` | Toggle Wrap                  |
| `<Leader>ul` | Toggle Line Numbers          |
| `<Leader>uL` | Toggle Relative Numbers      |
| `<Leader>ud` | Toggle Diagnostics           |
| `<Leader>uh` | Toggle Inlay Hints           |
| `<Leader>ug` | Toggle Indent Guides         |
| `<Leader>uT` | Toggle Treesitter            |
| `<Leader>uc` | Toggle Conceal               |
| `<Leader>ub` | Toggle Dark/Light Background |

### Treesitter (nvim-treesitter)

コード編集全般の AST ベースシンタックスハイライト・インデントを提供。noice.nvim のコマンドラインハイライトにも利用される。

- `ensure_installed`: noice.nvim 推奨パーサー + 作業言語 (TypeScript, PHP 等)
- `auto_install`: 未インストールの言語を開くと自動でパーサーをインストール
- 100KB 以上のファイルではハイライトを自動で無効化 (パフォーマンス保護)

#### Textobjects (nvim-treesitter-textobjects)

**Select** — オペレータ (`d`, `c`, `y`, `v`) と組み合わせて使用:

| テキストオブジェクト | 対象                           |
| -------------------- | ------------------------------ |
| `af` / `if`          | 関数 (outer/inner)             |
| `ac` / `ic`          | クラス (outer/inner)           |
| `aa` / `ia`          | 引数・パラメータ (outer/inner) |
| `al` / `il`          | ループ (outer/inner)           |

**Move** — 関数/クラス間ジャンプ:

| キー        | 説明                |
| ----------- | ------------------- |
| `]m` / `[m` | 次/前の関数の先頭   |
| `]M` / `[M` | 次/前の関数の末尾   |
| `]]` / `[[` | 次/前のクラスの先頭 |

**Swap** — 引数の入れ替え:

| キー         | 説明               |
| ------------ | ------------------ |
| `<Leader>xa` | 引数を次と入れ替え |
| `<Leader>xA` | 引数を前と入れ替え |

### LSP (nvim-lspconfig + mason.nvim)

Language Server Protocol による言語支援。mason.nvim でサーバー・ツールを自動インストール。

**自動インストールされる LSP サーバー:**

- `ts_ls` — TypeScript / JavaScript
- `intelephense` — PHP
- `lua_ls` — Lua (Neovim ランタイム認識)

**自動インストールされるツール:**

- フォーマッター: `prettier`, `stylua`, `php-cs-fixer`
- リンター: `eslint_d`, `phpstan`

| キー         | 説明                                                  |
| ------------ | ----------------------------------------------------- |
| `D`          | LSP: Hover Documentation (関数定義・ドキュメント表示) |
| `gK`         | LSP: Signature Help                                   |
| `<Leader>rn` | LSP: Rename Symbol                                    |
| `<Leader>ra` | LSP: Code Action (normal/visual)                      |
| `gl`         | LSP: Line Diagnostics                                 |
| `<Leader>F`  | Format Buffer (conform.nvim)                          |

### Completion (blink.cmp)

Rust 製の高速補完エンジン。LSP・スニペット・パス・バッファの 4 ソースから補完。

- ゴーストテキスト表示
- ドキュメント自動表示 (200ms 遅延)
- キーマップ: `default` プリセット (`<C-space>` で手動トリガー、`<C-y>` で確定、`<C-e>` でキャンセル)

### Formatter (conform.nvim)

| filetype                                               | formatter    |
| ------------------------------------------------------ | ------------ |
| TypeScript / JavaScript / JSON / HTML / CSS / Markdown | prettier     |
| PHP                                                    | php-cs-fixer |
| Lua                                                    | stylua       |

- **保存時自動フォーマット** (timeout 1s)
- `<Leader>F` で手動フォーマット
- `:ConformInfo` でフォーマッター状態確認

### Linter (nvim-lint)

| filetype                | linter   |
| ----------------------- | -------- |
| TypeScript / JavaScript | eslint_d |
| PHP                     | phpstan  |

- トリガー: ファイル保存時・開いた時・Insert モード離脱時

### AI Sidekick (sidekick.nvim)

Neovim 内で AI CLI ツール (Claude Code 等) を操作し、Copilot NES (Next Edit Suggestions) をインラインで適用できるプラグイン。

| キー         | 説明                              |
| ------------ | --------------------------------- |
| `<C-.>`      | Sidekick CLI をトグル (全モード)  |
| `<Leader>aa` | Sidekick CLI をトグル             |
| `<Leader>as` | CLI ツールを選択                  |
| `<Leader>ad` | CLI セッションをデタッチ          |
| `<Leader>at` | カーソル位置のコードを CLI に送信 |
| `<Leader>af` | 現在のファイルを CLI に送信       |
| `<Leader>av` | ビジュアル選択を CLI に送信       |
| `<Leader>ap` | プロンプトを選択                  |
| `<Leader>ac` | Claude を直接トグル               |

### Motion (flash.nvim)

easy-motion 系のジャンプナビゲーション。`s` を押して文字を入力すると、画面上の候補にラベルが表示され、1〜2 キーで瞬時にジャンプできる。

| キー    | モード  | 説明                                            |
| ------- | ------- | ----------------------------------------------- |
| `s`     | n, x, o | Flash: 文字検索ジャンプ                         |
| `S`     | n, o    | Flash Treesitter: 構文ノード単位で選択          |
| `r`     | o       | Remote Flash: リモートジャンプ (オペレータ待ち) |
| `R`     | o, x    | Treesitter Search: 構文ベース検索               |
| `<C-s>` | c       | `/` 検索中に Flash のラベルジャンプを切替       |

- `f`/`F`/`t`/`T` も拡張され、複数候補にラベルが表示される
- ビルトイン `s` (substitute) は `cl` で代替可能

### Surround (nvim-surround)

テキストの囲み文字（括弧・クォート等）を追加・削除・変更する。

| キー               | モード | 説明                                          |
| ------------------ | ------ | --------------------------------------------- |
| `ys{motion}{char}` | n      | 囲みを追加 (例: `ysiw"` → word を `"` で囲む) |
| `yss{char}`        | n      | 行全体を囲む                                  |
| `ds{char}`         | n      | 囲みを削除 (例: `ds"` → `"` を削除)           |
| `cs{old}{new}`     | n      | 囲みを変更 (例: `cs"'` → `"` を `'` に)       |
| `S{char}`          | x      | visual 選択範囲を囲む                         |

### Noice (noice.nvim)

| キー          | 説明                                              |
| ------------- | ------------------------------------------------- |
| `<S-Enter>`   | コマンドライン出力をリダイレクト (cmdline モード) |
| `<Leader>snl` | 最後のメッセージを表示                            |
| `<Leader>snh` | メッセージ履歴                                    |
| `<Leader>sna` | 全メッセージ                                      |
| `<Leader>snd` | 通知をすべて消す                                  |

## claude-mem (ChromaDB)

claude-mem プラグインのセマンティック検索機能には ChromaDB が必要です。ChromaDB は独立したプロセスのため、**PC 再起動後も自動起動するよう launchd に登録することを推奨**します。

### セットアップ

```sh
# 1. ChromaDB をインストール
uv tool install chromadb

# 2. データディレクトリを作成
mkdir -p ~/.local/share/chromadb

# 3. LaunchAgent plist を配置 (下記参照)
# ~/Library/LaunchAgents/local.chromadb.plist

# 4. サービスを登録・起動
launchctl load ~/Library/LaunchAgents/local.chromadb.plist

# 5. 動作確認
curl -s http://localhost:18000/api/v2/heartbeat
```

ポートはデフォルトの 8000 から **18000** に変更しています（衝突回避）。`.zshenv` で `CLAUDE_MEM_CHROMA_PORT=18000` を export し、claude-mem 側の接続先を環境変数で上書きしています。

### 管理コマンド

```sh
# 停止
launchctl unload ~/Library/LaunchAgents/local.chromadb.plist

# 起動
launchctl load ~/Library/LaunchAgents/local.chromadb.plist

# 状態確認
curl -s http://localhost:18000/api/v2/heartbeat
```

> **注意:** launchd plist を配置せずに使うと、PC 再起動後に ChromaDB が停止し、claude-mem のメモリ検索が機能しなくなります（degraded mode）。

## 参考記事

- [defaultsコマンド](http://neos21.hatenablog.com/entry/2019/01/10/080000)
- [defauls一覧](https://github.com/ulwlu/dotfiles/blob/master/system/macos.sh)
- [setup.shまとめ](https://qiita.com/kai_kou/items/af5d0c81facc1317d836)
- [環境構築系記事](https://qiita.com/kai_kou/items/3107e0a056c7a1b569cd)
- [Gistについて](https://qiita.com/hkusu/items/18cbe582abb9d3172019)
