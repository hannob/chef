#
# Cookbook Name:: chef
# Recipe:: repository
#
# Copyright 2013, OpenStreetMap Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "git"

keys = data_bag_item("chef", "keys")

directory "/var/lib/chef" do
  owner "chefrepo"
  group "chefrepo"
  mode 02775
end

git "/var/lib/chef" do
  action :checkout
  repository node[:chef][:repository]
  revision "master"
  user "chefrepo"
  group "chefrepo"
end

directory "/var/lib/chef/.chef" do
  owner "chefrepo"
  group "chefrepo"
  mode 02775
end

file "/var/lib/chef/.chef/client.pem" do
  content keys["chef-git"].join("\n")
  owner "chefrepo"
  group "chefrepo"
  mode 0660
end

cookbook_file "/var/lib/chef/.chef/knife.rb" do
  source "knife.rb"
  owner "chefrepo"
  group "chefrepo"
  mode 0660
end

template "#{node[:chef][:repository]}/hooks/post-receive" do
  source "post-receive.erb"
  owner "chefrepo"
  group "chefrepo"
  mode 0750
end

template "/etc/cron.daily/chef-repository-backup" do
  source "repository-backup.cron.erb"
  owner "root"
  group "root"
  mode 0755
end
