# == Schema Information
#
# Table name: repositories
#
#  id         :integer          not null, primary key
#  project_id :integer
#  remote_url :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Repository < ActiveRecord::Base
  after_commit   :clone_async, on: :create
  before_destroy :remove_repo

  belongs_to :project

  def clone  
    Rugged::Repository.clone_at(remote_url, local_path)
  end

  def local_path
    @local_path ||= [ Cointegrator::Application.config.repos_path, id.to_s, project.name ].join '/'
  end

  def cloned?
    Pathname.new(local_path + '/.git/HEAD').exist?
  end

  def clone_async
    Git::ClonerJob.perform_later self
  end

  def git
    return nil unless cloned?
    @git ||= Rugged::Repository.new(local_path)
  end

  def pull
    git.remotes.each { |remote| remote.fetch }
  end

  private
    def remove_repo
      FileUtils.rm_rf(local_path)
    end
end
