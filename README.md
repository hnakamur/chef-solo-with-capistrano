# chef-solo with capistrano

chef-solo を capistrano で実行する例

## 前提

* chef-solo が各ホストにインストール済み
* capistrano をするホストから各ホストに ssh でログインできる

## 設定

ファイルを配置するディレクトリは/etc/chef固定です。
(Convention over Configurationです。またこうしておけばホストにログインして
直接chef-soloを実行するときに単にchef-soloと打つだけですみます。/etc/chef/solo.rbはデフォルトなので-cオプションは不要。/etc/chef/solo.rbにjson_attribsを指定しているので-jオプションも不要)

cap chef HOSTS=host1,host2
のように実行先のホストを指定して実行します。

capistranoを起動したホストからそれぞれのホストに/etc/chef/以下の内容がコピーされた後、hosts/{hostname}.json を使って chef-solo が実行されます。

## 実行例

    # cap -T
    cap chef:run_chef # run chef-solo
    cap chef:sync     # rsync /root/chef
    cap invoke        # Invoke a single command on the remote servers.
    cap shell         # Begin an interactive Capistrano session.
    
    # cap chef
      * executing `chef'
      * executing `chef:init_config'
      * executing `chef:sync'
      * executing `chef:merge_json'
      * executing "cd /root/chef && export HOST=`hostname -s`; ./bin/merge_json json/base.json json/${HOST}.json > config/self.json"
        servers: ["web01", "app01"]
        [web01] executing command
        [app01] executing command
        command finished in 89ms
      * executing `chef:run_chef'
      * executing "chef-solo -c /root/chef/config/solo.rb -j /root/chef/config/self.json"
        servers: ["web01", "app01"]
        [app01] executing command
        [web01] executing command
     ** [out :: web01] [2012-07-04T19:33:46+09:00] INFO: *** Chef 10.12.0 ***
     ** [out :: app01] [2012-07-04T19:33:46+09:00] INFO: *** Chef 10.12.0 ***
     ** [out :: app01] [2012-07-04T19:33:46+09:00] INFO: Setting the run_list to ["os-defaults"] from JSON
     ** [out :: app01] [2012-07-04T19:33:46+09:00] INFO: Run List is [recipe[os-defaults]]
     ** [out :: app01] [2012-07-04T19:33:46+09:00] INFO: Run List expands to [os-defaults]
     ** [out :: app01] [2012-07-04T19:33:46+09:00] INFO: Starting Chef Run for app01
     ** [out :: app01] [2012-07-04T19:33:46+09:00] INFO: Running start handlers
     ** [out :: app01] [2012-07-04T19:33:46+09:00] INFO: Start handlers complete.
     ** [out :: app01] [2012-07-04T19:33:46+09:00] INFO: Processing template[/etc/resolv.conf] action create (os-defaults::default line 2)
     ** [out :: app01] [2012-07-04T19:33:46+09:00] INFO: Chef Run complete in 0.006611 seconds
     ** [out :: app01] [2012-07-04T19:33:46+09:00] INFO: Running report handlers
     ** [out :: app01] [2012-07-04T19:33:46+09:00] INFO: Report handlers complete
     ** [out :: web01] [2012-07-04T19:33:46+09:00] INFO: Setting the run_list to ["os-defaults"] from JSON
     ** [out :: web01] [2012-07-04T19:33:46+09:00] INFO: Run List is [recipe[os-defaults]]
     ** [out :: web01] [2012-07-04T19:33:46+09:00] INFO: Run List expands to [os-defaults]
     ** [out :: web01] [2012-07-04T19:33:46+09:00] INFO: Starting Chef Run for web01
     ** [out :: web01] [2012-07-04T19:33:46+09:00] INFO: Running start handlers
     ** [out :: web01] [2012-07-04T19:33:46+09:00] INFO: Start handlers complete.
     ** [out :: web01] [2012-07-04T19:33:46+09:00] INFO: Processing template[/etc/resolv.conf] action create (os-defaults::default line 2)
     ** [out :: web01] [2012-07-04T19:33:46+09:00] INFO: Chef Run complete in 0.010748 seconds
     ** [out :: web01] [2012-07-04T19:33:46+09:00] INFO: Running report handlers
     ** [out :: web01] [2012-07-04T19:33:46+09:00] INFO: Report handlers complete
        command finished in 861ms

## License

* The MIT License (MIT)
* Copyright (c) 2012- FUJIWARA Shunichiro
