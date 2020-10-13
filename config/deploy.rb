# config valid for current version and patch releases of Capistrano
lock "~> 3.14.1"

set :application, "slack_clone"
set :repo_url, "git@github.com:SlackClone/slack_clone.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
# set :deploy_to, "/home/deploy/staging"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"
append :linked_files, "config/database.yml", "config/master.key", "config/credentials.yml.enc", "config/application.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# FIXME: Replace rvm with rbenv or compile ruby source code for production environment, rvm just for development
# set :default_env, { path: "/usr/local/ruby-2.6.5/bin:/usr/local/rvm/rubies/ruby-2.6.5/bin:$PATH" }

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Default value for keep_releases is 5
set :keep_releases, 5

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure

# Choose & deploy specific branch each time
# ask :branch

set :branch, ENV.fetch("CAPISTRANO_BRANCH", "develop")
# Using following command to deploy specific branch
# CAPISTRANO_BRANCH=my-feature cap staging deploy
