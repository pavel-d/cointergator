# == Schema Information
#
# Table name: containers
#
#  id                  :integer          not null, primary key
#  image_id            :string
#  docker_container_id :string
#  name                :string
#  branch_name         :string
#  project_id          :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class Container < ActiveRecord::Base
  belongs_to :project
  has_one :repository, through: :project

  after_commit   :setup_container, on: :create
  before_destroy :destroy_container, :if => proc { ready? }
  before_destroy :delete_slug

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
    return [] unless ports
    ports.map { |port| "http://#{ip.to_s}:#{port.join[/\d+/]}" }
  end

  def info
    ready? ? docker_container.info : {}
  end

  def slug_name
    "#{project.name}_#{id}.tgz"
  end

  def slug_path
    @slug_path ||= [ slug_dir, slug_name ].join '/'
  end

  def slug_dir
    [ Cointegrator::Application.config.slugs_path, id ].join '/'
  end

  private
    def destroy_container
      Containers::DestroyerJob.perform_later self
    end

    def delete_slug
      FileUtils.rm_rf slug_dir
    end

    def setup_container
      Containers::SlugBuilderJob.perform_later self
    end
end
