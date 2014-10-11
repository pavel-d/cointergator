class Docker::ContainerBuilderJob < ActiveJob::Base
  queue_as :default

  def perform(container)
    container.repository.git.checkout container.branch_name
    
    img = Docker::Image.build_from_dir(container.repository.local_path)

    img.tag repo: "#{container.project.name}:#{container.branch_name}"

    warn "#{container.project.name}:#{container.branch_name}"

    docker_container = img.run

    container.update(image_id: img.id, docker_container_id: docker_container.id)
  end
end
