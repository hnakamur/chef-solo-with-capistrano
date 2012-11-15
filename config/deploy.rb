require "json"

set :application, "chef-solo"
set :hostname,    `hostname -s`.chomp

namespace :chef do

  task :default do
    sync
    run_chef
  end

  desc "run chef-solo"
  task :run_chef, :roles => :host do
    run "chef-solo"
  end

  desc "rsync /etc/chef"
  task :sync do
    find_servers_for_task(current_task).each do |server|
      next if server.host == hostname
      `rsync -avC --delete -e ssh /etc/chef/ #{server.host}:/etc/chef/`
    end
  end

end

