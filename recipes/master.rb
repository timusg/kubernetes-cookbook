# Encoding: utf-8
# Cookbook Name:: kubernetes-cookbook
# Recipe:: default
#
# Copyright (C) 2016 timusg
#
# All rights reserved - Do Not Redistribute

etcd_service 'etcd' do
  advertise_client_urls 'http://0.0.0.0:2379'
  listen_client_urls 'http://0.0.0.0:2379'
  initial_advertise_peer_urls 'http://127.0.0.1:2380'
  listen_peer_urls 'http://localhost:2380'
  action :start
end

[ "kubernetes-master",
  "flannel",
].each do |pkg|
  package pkg
end

temaplate '/etc/kubernetes/config' do
  source 'kubernetes-config.erb'
end

temaplate '/etc/kubernetes/apiserver' do
  source 'kubernetes-apiserver.erb'
end

temaplate '/etc/sysconfig/flanneld' do
  source 'flanneld.erb'
end

etcd_key "coreos.com/network/config" do
  value %{
{
  "Network": "10.20.0.0/16",
  "SubnetLen": 24,
  "Backend": {
  "Type": "vxlan",
  "VNI": 1
  }
}
  }
  action :set
end

service "firewalld" do
  action [ :disable, :stop ]
end

[ "flanneld",
  "kube-scheduler",
  "kube-controller-manager",
  "kube-apiserver",
  "etcd"
].each do |service|
  service service do
    action [ :enable, :start ]
  end
end
