# == Schema Information
#
# Table name: containers
#
#  id           :integer          not null, primary key
#  image_id     :string
#  container_id :string
#  name         :string
#  branch_name  :string
#  project_id   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Container < ActiveRecord::Base
  belongs_to :project
  has_one :repository, through: :project

  after_commit   :setup_container, on: :create
  before_destroy :kill_container, :if => proc { ready? }

  def ready?
    !!docker_container_id
  end

  def docker_container
    return nil unless ready?
    @docker_container ||= Docker::Container.get docker_container_id
  end

  def name
    info['Name']
  end

  def ip
    info['NetworkSettings']['IPAddress']
  end

  def ports
    info['NetworkSettings']['Ports']
  end

  def urls
    ports.map { |port| "http://#{ip.to_s}:#{port.join[/\d+/]}" }
  end

  def info
    ready? ? docker_container.info : {}
  end

  def kill_container
    begin
      docker_container.kill
    rescue Docker::Error::NotFoundError => e
      # Already destroyed
      true
    end
  end

  private

    def setup_container
      Docker::ContainerBuilderJob.perform_later self
    end
end
