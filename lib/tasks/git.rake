namespace :git do
  desc "Clean unused git repositories"
  task cleanup: :environment do

    REPOS_PATH = 'repos/'

    ids = Repository.all.pluck(:id)
    repos_ids = Pathname.glob("#{REPOS_PATH}*").map { |f| f.basename.to_s.to_i }

    useless = repos_ids - ids

    puts "Removing unused git repositories: #{useless}"

    useless.each { |folder_name| FileUtils.rm_rf( [REPOS_PATH, folder_name].join('/') ) }

    puts "#{useless.count} repository(s) removed."
  end
end
