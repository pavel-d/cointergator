class Git::ClonerJob < ActiveJob::Base
  queue_as :default

  def perform(repository)
    repository.clone
  end
end
