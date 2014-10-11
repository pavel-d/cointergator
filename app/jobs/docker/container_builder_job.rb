class Docker::ContainerBuilderJob < ActiveJob::Base
  queue_as :default

  def perform(container)
    
    img_build_logs = %x(git archive master | docker run -i -a stdin -a stdout flynn/slugbuilder)

    # img.tag repo: "#{container.project.name}:#{container.branch_name}"

    # warn "#{container.project.name}:#{container.branch_name}"

    # docker_container = img.run

    # container.update(image_id: img.id, docker_container_id: docker_container.id)
  end
end
