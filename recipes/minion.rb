# Encoding: utf-8
# Cookbook Name:: kubernetes-cookbook
# Recipe:: default
#
# Copyright (C) 2016 timusg
#
# All rights reserved - Do Not Redistribute

[ "flannel",
  "docker",
  "kubernetes-node",
].each do |pkg|
  package pkg
end


service "firewalld" do
  action [ :disable, :stop ]
end
