#
# Cookbook Name:: nagios-herald
# Recipe:: default
#
# Copyright (C) 2014 ShowMobile, LLC
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
