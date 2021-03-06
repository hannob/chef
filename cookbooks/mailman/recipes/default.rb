#
# Cookbook Name:: mailman
# Recipe:: default
#
# Copyright 2011, OpenStreetMap Foundation
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

include_recipe "apache::ssl"

package "mailman"

service "mailman" do
  action [ :enable, :start ]
  supports :restart => true, :reload => true
end

apache_module "expires"
apache_module "rewrite"

apache_site "lists.openstreetmap.org" do
  template "apache.erb"
end

template "/etc/cron.daily/lists-backup" do
  source "backup.cron.erb"
  owner "root"
  group "root"
  mode 0755
end
