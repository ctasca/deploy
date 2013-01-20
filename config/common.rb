ssh_options[:forward_agent] = true
default_run_options[:pty] = true

set :user, "ctasca"
set :db_host, "localhost"
set :db_user, "root"
set :mysql_path, "/Applications/MAMP/Library/bin/mysql"
set :scm, :git
set :use_sudo, false

# Prompt
set(:db_name) {Capistrano::CLI.ui.ask("Enter DB name")}
set(:db_password) {Capistrano::CLI.ui.ask("Enter DB password")}
set(:branch_prompt) {Capistrano::CLI.ui.ask("Enter ±Git branch name")}
set(:deploy_to) {Capistrano::CLI.ui.ask("Deploy to...")}

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"
after "deploy:restart", "deploy:cleanup"

role :web, "localhost"                          # Your HTTP server, Apache/etc
role :db,  "localhost", :primary => true