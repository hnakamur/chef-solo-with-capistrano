file_cache_path '/tmp/chef-solo'
cookbook_path   '/etc/chef/cookbooks'
json_attribs    '/etc/chef/hosts//%s.json' % `hostname -s`.chomp
role_path       '/etc/chef/roles'
node_name       `hostname -s`.chomp
log_level       :debug
