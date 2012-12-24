file_cache_path '/tmp/chef-solo'
cookbook_path   '/etc/chef/cookbooks'
json_attribs    '/etc/chef/nodes/%s.json' % `hostname -s`.chomp
role_path       '/etc/chef/roles'
node_name       `hostname -s`.chomp
log_location    '/var/log/chef/solo.log'
log_level       :debug
