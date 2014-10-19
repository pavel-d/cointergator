class Containers::DestroyerJob < ActiveJob::Base
  queue_as :default

  def perform(container)
  	begin
      container.docker_container.kill
    rescue Docker::Error::NotFoundError => e
      # Already killed
      true
    end
  	
    container.docker_container.delete(:force => true)
  end
end
