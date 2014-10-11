namespace :docker do
  desc 'Remove all stopped containers'
  task :cleanup do
    removed = Docker::Container.all(all: true).select {|c| c.info['Status'] =~ /Exited/ }.each(&:delete)
    puts "#{removed.count} container(s) removed"
  end
end
