namespace :git do
  desc "Clean unused git repositories"
  task cleanup: :environment do

    repos_path = Cointegrator::Application.config.repos_path

    ids = Repository.all.pluck(:id)
    repos_ids = Pathname.glob("#{repos_path}*").map { |f| f.basename.to_s.to_i }

    useless = repos_ids - ids

    puts "Removing unused git repositories: #{useless}"

    useless.each { |folder_name| FileUtils.rm_rf( [repos_path, folder_name].join('/') ) }

    puts "#{useless.count} repository(s) removed."
  end
end

namespace :data do
  namespace :cleanup do

    desc "Clean all unused data (git repositories, docker containers, compiled slugs)"
    task all: :environment do
      ['git', 'slugs', 'docker'].each do |task|
        Rake::Task["data:cleanup:#{task}"].invoke
      end
    end

    desc "Remove unused git repositories"
    task git: :environment do
      repos_path = Cointegrator::Application.config.repos_path

      ids = Repository.all.pluck(:id)
      repos_ids = Pathname.glob("#{repos_path}/*").map { |f| f.basename.to_s.to_i }

      useless = repos_ids - ids

      useless.each { |folder_name| FileUtils.rm_rf( [repos_path, folder_name].join('/') ) }

      puts "#{useless.count} repository(s) removed."
    end

    desc "Remove unused compiled slugs"
    task slugs: :environment do
      slugs_path = Cointegrator::Application.config.slugs_path

      ids = Container.all.pluck(:id)
      repos_ids = Pathname.glob("#{slugs_path}/*").map { |f| f.basename.to_s.to_i }

      useless = repos_ids - ids

      useless.each { |folder_name| FileUtils.rm_rf( [slugs_path, folder_name].join('/') ) }

      puts "#{useless.count} slug(s) removed."
    end

    desc 'Remove all stopped containers'
    task :docker do
      removed = Docker::Container.all(all: true).select {|c| c.info['Status'] =~ /Exited/ }.each(&:delete)
      puts "#{removed.count} container(s) removed."
    end
  end # cleanup
end