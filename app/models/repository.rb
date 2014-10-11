# == Schema Information
#
# Table name: repositories
#
#  id         :integer          not null, primary key
#  project_id :integer
#  remote_url :string
#  local_path :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Repository < ActiveRecord::Base
  after_commit   :clone_async, on: :create
  before_destroy :remove_repo

  belongs_to :project

  def clone
    dir = Rails.root.join 'repos', id.to_s, project.name
  
    Rugged::Repository.clone_at(remote_url, dir.to_s)

    update(local_path: dir)
  end

  def cloned?
    !!local_path
  end

  def clone_async
    Git::ClonerJob.perform_later self
  end

  def git
    return nil unless local_path
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
