#
# Cookbook Name:: nagios-herald
# Recipe:: default
#
# Copyright (C) 2014 Jake Plimack Photography, LLC
#
# All rights reserved - Do Not Redistribute
#

node[:nagios][:herald][:packages].each do |pkg|
  package pkg
end

node[:nagios][:herald][:cookbooks].each do |cb|
  include_recipe cb
end

node[:nagios][:herald][:gems].each do |gem|
  gem_package gem
end

node[:nagios][:herald][:pips].each do |pip|
  python_pip pip
end

if Chef::Config[:solo]
  directory node[:nagios][:home] do
    owner node[:nagios][:user]
    group node[:nagios][:group]
  end
end

herald_path = "#{node[:nagios][:home]}/herald"
herald_bin = "#{herald_path}/bin/nagios-herald"

git herald_path do
  repository node[:nagios][:herald][:repo]
  revision node[:nagios][:herald][:rev]
  action :sync
end

cmds = {
  'notify_host_by_email' => {
    'id' => 'herald-notify-host-by-email',
    'command_line' => "#{herald_bin} --message-type email --formatter=$_HOSTMESSAGE_FORMATTER_NAME$ --nagios-cgi-url=#{node[:nagios][:url]}/cgi-bin/cmd.cgi
--reply-to=#{node[:nagios][:herald][:reply_to]}"
  },
  'notify_service_by_email' => {
    'id' => 'herald-notify-service-by-email',
    'command_line' => "#{herald_bin} --message-type email --formatter=$_SERVICEMESSAGE_FORMATTER_NAME$ --nagios-cgi-url=#{node[:nagios][:url]}/cgi-bin/cmd.cgi
--reply-to=#{node[:nagios][:herald][:reply_to]}"
  },
  'notify_host_by_pager' => {
    'id' => 'herald-notify-service-by-pager',
    'command_line' => "#{herald_bin} --message-type pager --formatter=$_SERVICEMESSAGE_FORMATTER_NAME$ --nagios-cgi-url=#{node[:nagios][:url]}/cgi-bin/cmd.cgi
--reply-to=#{node[:nagios][:herald][:reply_to]}"
  },
  'notify_service_by_pager' => {
    'id' => 'herald-notify-service-by-pager',
    'command_line' => "#{herald_bin} --message-type pager --formatter=$_SERVICEMESSAGE_FORMATTER_NAME$ --nagios-cgi-url=#{node[:nagios][:url]}/cgi-bin/cmd.cgi
--reply-to=#{node[:nagios][:herald][:reply_to]}"
  },
  'notify_host_by_irc' => {
    'id' => 'herald-notify-service-by-irc',
    'command_line' => "#{herald_bin} --message-type irc --formatter=$_SERVICEMESSAGE_FORMATTER_NAME$ --nagios-cgi-url=#{node[:nagios][:url]}/cgi-bin/cmd.cgi
--reply-to=#{node[:nagios][:herald][:reply_to]}"
  },
  'notify_service_by_irc' => {
    'id' => 'herald-notify-service-by-irc',
    'command_line' => "#{herald_bin} --message-type irc --formatter=$_SERVICEMESSAGE_FORMATTER_NAME$ --nagios-cgi-url=#{node[:nagios][:url]}/cgi-bin/cmd.cgi
--reply-to=#{node[:nagios][:herald][:reply_to]}"
  }
}

cmds.each do |cmd_name, cmd_vals|
  Chef::Log.info("Creating DataBag('nagios_services:#{cmd_name}')")
  databag_item = Chef::DataBagItem.new
  databag_item.data_bag('nagios_services')
  databag_item.raw_data = cmd_vals
  if Chef::Config[:solo]
    dbag = "#{Chef::Config[:data_bag_path]}/nagios_services/herald-#{cmd_name}.json"
    File.open(dbag, 'w') { |file| file.write(cmd_vals.to_json) }
  else
    databag_item.save
  end
end
