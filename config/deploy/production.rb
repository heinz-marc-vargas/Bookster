set :dns_name, '180.150.140.166'

role :web, dns_name                          # Your HTTP server, Apache/etc
role :app, dns_name                          # This may be the same as your `Web` server
role :db,  dns_name, :primary => true        # This is where Rails migrations will run

set :deploy_to, "/home/heinz/production"

set :rails_env, 'production'
set :branch, 'flattheme'
set :use_sudo, false

set :user, 'heinz'
set :password, 'Ap0ll0$2000'

set :port, 22
