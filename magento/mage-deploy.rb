load 'config/common.rb'
load 'config/project.rb'
# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

namespace :mage do
    desc "Install Magento with default data"
    task :install_with_sample, :roles => :web do
        run <<-CMD
        cd #{deploy_to} ; curl -O http://www.magentocommerce.com/downloads/assets/#{mage_version}/magento-#{mage_version}.tar.gz &> /dev/null ; curl -O http://www.magentocommerce.com/downloads/assets/#{mage_data_version}/magento-sample-data-#{mage_data_version}.tar.gz &> /dev/null ;
        tar -zxvf magento-#{mage_version}.tar.gz ;
        tar -zxvf magento-sample-data-#{mage_data_version}.tar.gz ;
        mv magento-sample-data-#{mage_data_version}/media/* magento/media/ ;
        mv magento-sample-data-#{mage_data_version}/magento_sample_data_for_#{mage_data_version}.sql magento/data.sql ;
        mv magento/* magento/.htaccess . ;
        chmod -R o+w media  ;
        chmod o+w var var/.htaccess app/etc  ;
        rm -rf magento/ magento-sample-data-#{mage_data_version}/ magento-#{mage_version}.tar.gz magento-sample-data-#{mage_data_version}.tar.gz ;
        CMD
    end
    desc "Import data.sql"
    task :import_sample_data, :roles => :db do
        run <<-CMD
        cd #{deploy_to} ;
        #{mysql_path} -u #{db_user} -p#{db_password} #{db_name} < data.sql ;
        rm data.sql ;
        CMD
    end
    desc "GIT clone"
    task :git_clone, roles => :web do
        run <<-CMD
        cd #{deploy_to} ;
        git clone #{repository} . ;
        CMD
    end;
    task :git_init, roles => :web do
        run <<-CMD
        cd #{deploy_to} ;
        git init ;
        git remote add origin #{repository} ;
        CMD
    end;
    task :git_commit, roles => :web do
        run <<-CMD
        cd #{deploy_to} ;
        rm .gitignore;
        touch .gitignore ;
        echo '/downloader/' > .gitignore ;
        echo '/media/' >> .gitignore ;
        echo '/var/' >> .gitignore ;
        echo '/vendor/' >> .gitignore ;
        git add . ;
        git commit -m "mage installation commit" ;
        CMD
    end;
    task :git_pull_origin, roles => :web do
        run <<-CMD
        cd #{deploy_to} ;
        git pull origin #{branch_prompt} ;
        CMD
    end;
    task :git_push_origin, roles => :web do
        run <<-CMD
        cd #{deploy_to} ;
        git push origin #{branch_prompt} ;
        CMD
    end;
    task :pwd, roles => :web do
        run <<-CMD
        pwd
        CMD
    end;
end
