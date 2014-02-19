#SSHKit.config.command_map[:rake] = "bundle exec rake"

# config valid only for Capistrano 3.1
lock '3.1.0'

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, '2.1.0'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
set :user, "deployer"
set :application, 'blog'
set :repo_url, 'git@github.com:enter08/blog.git'

# Default value for :linked_files is []
 set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
 set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

 # SSHKit.config.command_map[:rake] = "bundle exec rake"
 # SSHKit.config.command_map[:rails] = "bundle exec rails"


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
 set :deploy_to, '/home/deployer/apps/blog'

# Default value for :scm is :git
 set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
 set :pty, true
 set :ssh_options, { :forward_agent => true }

#after :finishing, 'deploy:cleanup'

namespace :deploy do

  task :start do
      on roles(:all) do
        execute "/etc/init.d/unicorn_#{fetch(:application)} start"
      end
    end

    description 'Application stopped!'
    task :stop do
      on roles(:all) do
        execute "/etc/init.d/unicorn_#{fetch(:application)} stop"
      end
    end

    task :restart do
      on roles(:all) do
        execute "/etc/init.d/unicorn_#{fetch(:application)} restart"
      end
    end

  task :setup_config do
    on roles(:app) do
      sudo "ln -nfs /home/deployer/apps/blog/current/config/nginx.conf /etc/nginx/sites-enabled/#{fetch(:application)}"
      sudo "ln -nfs /home/deployer/apps/blog/current/config/unicorn_init.sh /etc/init.d/unicorn_#{fetch(:application)}"
      #execute "mkdir -p #{fetch(:shared_path)}/config"
      #put File.read("config/database.example.yml"), "#{shared_path}/config/database.yml"
      puts "Now edit the config files in #{fetch(:shared_path)}."
    end
  end

  after :finishing, 'deploy:setup_config'

end

  # %w[start stop restart].each do |command|
  #   desc "fetch(#{command}) unicorn server"
  #   task command do
  #   on roles(:app) do
  #     execute "/etc/init.d/unicorn_#{fetch(:application)} #{fetch(:command)}"
  #   end
  #   end
  # end

  # make sure we're deploying what we think we're deploying
  # before :deploy, "deploy:check_revision"
  # # only allow a deploy with passing tests to deployed
  # before :deploy, "deploy:run_tests"
  # # compile assets locally then rsync
  # after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
  


# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

# namespace :deploy do

#   desc 'Restart application'
#   task :restart do
#     on roles(:app), in: :sequence, wait: 5 do
#       # Your restart mechanism here, for example:
#       # execute :touch, release_path.join('tmp/restart.txt')
#     end
#   end

#   after :publishing, :restart

#   after :restart, :clear_cache do
#     on roles(:web), in: :groups, limit: 3, wait: 10 do
#       # Here we can do anything such as:
#       # within release_path do
#       #   execute :rake, 'cache:clear'
#       # end
#     end
#   end

# end