#
# Cookbook Name:: postgres
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package "postgresql-server" do
     action :install
end

# DBの初期化コマンドの実行
# 冪等性を維持するため実行済みか否かをディレクトリの有無で判断
dataDir = "/var/lib/pgsql/data/"
if not File.exists? dataDir then
   execute "postgresql-init" do
      command "service postgresql initdb"
   end
end

# 外部からの接続許可のための設定ファイル書き換え
template "/var/lib/pgsql/data/pg_hba.conf" do
   mode 0600
end

template "/var/lib/pgsql/data/postgresql.conf" do
   mode 0600
end

# 再起動と自動起動設定
service "postgresql" do
    action [:enable, :restart]
end

# IPテーブルの設定が邪魔なので停止
service "iptables" do
   action [:disable, :stop]
end

