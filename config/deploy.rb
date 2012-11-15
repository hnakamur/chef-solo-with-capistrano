require "json"

set :application, "chef-solo"
set :chef_dir,    "/etc/chef"
set :hostname,    `hostname -s`.chomp

namespace :chef do

  task :default do
    init_config
    sync
    run_chef
  end

  task :init_config do
    File::open("#{chef_dir}/solo.rb", "w") {|f|
      f.write <<-EOF
file_cache_path '/tmp/chef-solo'
cookbook_path   '#{chef_dir}/cookbooks'
json_attribs    '#{chef_dir}/json//%s.json' % `hostname -s`.chomp
role_path       '#{chef_dir}/roles'
node_name       `hostname -s`.chomp
log_level       :debug
      EOF
    }
  end

  desc "run chef-solo"
  task :run_chef, :roles => :host do
    run "chef-solo -c #{chef_dir}/solo.rb"
  end

  desc "rsync #{chef_dir}"
  task :sync do
    find_servers_for_task(current_task).each do |server|
      next if server.host == hostname
      `rsync -avC --delete -e ssh #{chef_dir}/ #{server.host}:#{chef_dir}/`
    end
  end

end

