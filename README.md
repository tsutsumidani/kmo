## 開発環境準備



1. タスクバーにピン留めされた水色のクジラのアイコン(Docker Cuickstart Terminal)をクリック。
2. 自動でDockerが起動する。クジラのアスキーアートが表示されたら起動完了。
3. コマンドラインで`whale` と入力しエンターキー押下。この操作で開発に必要なデータが揃ったディレクトリに移動できる。
4. コマンドラインで`ll`と入力しエンターキー押下。このコマンドは、現在いるフォルダに置かれたファイルを見るためのもの。app, web, db, docker-compose.yml などのファイルが表示されるか確認する。



### Dockerコンテナ起動

1. 上のフォルダにいる状態で下記のコマンドを入力しエンターキー押下。

   ```bash
   sh start.sh
   ```

   下記のような表示が出れば起動OK.

   ```bash
   Creating whale_db_1_7096d34d8fe6 ... done
   Creating whale_web_1_d4c6fc83efef ... done
   .
   .
   .
   Bundle complete! 26 Gemfile dependencies, 88 gems now installed.
   Bundled gems are installed into `/usr/local/bundle`
   
   ```

   この状態で開発の準備が完了。

2. Visual Studio code という名前のアプリがインストールしてある。スタートメニューから検索して開く。ソースコードの配置されたフォルダが開くようになっているので、ポチポチ開発してみるとよい。



## Railsサーバ起動



1. 先ほどのクジラアイコンで開いたコマンドラインに戻り、下記のコマンドを入力しエンターキー押下。
   ```bash
   sh up_rails.sh
   ```
2. 下記のように表示されれば起動完了。

   ```
   => Booting Puma
   => Rails 5.1.4 application starting in development
   => Run `rails server -h` for more startup options
   Puma starting in single mode...
   * Version 3.12.0 (ruby 2.4.2-p198), codename: Llamas in Pajamas
   * Min threads: 5, max threads: 5
   * Environment: development
   * Listening on tcp://0.0.0.0:3000
   Use Ctrl-C to stop
   ```

3. ブラウザのURLバーに`localhost:3030`と入力。Yey! You're on Rails! とか書いた画面表示されたら正常。

   `localhost:3030/login`とか、作成したページのURLを入力してやるとよい。

   →（今のアプリは一度ログイン操作をしないと、ログイン画面にリダイレクトさせるよう実装しているので注意）

   サーバを停止する場合は`Ctrl + c`を入力する。



## コンテナ停止

1. 全て作業が終了し、開発環境を終了したい時はクジラアイコンのコマンドライン上で下記のコマンドを入力しエンターキー押下。

   ```bash
   sh  stop.sh
   ```

   クジラアイコンのコマンドラインを×ボタンクリックで普通に終了。



以上。