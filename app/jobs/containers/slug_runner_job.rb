class Containers::SlugRunnerJob < ActiveJob::Base
  queue_as :default

  def perform(container)

  puts 'Loading slug'
  
  File.open(container.slug_path, 'r') do |slug|
    log = slug_runner.tap(&:start).attach(stdin: slug, stdout: true, stderr: true, logs: true, tty: true)
    puts log.inspect

    puts slug_runner.id
  end

  puts 'Starting web'

  puts 'Running'  

  container.update(docker_container_id: slug_runner.id)
  
  end

  private
    def slug_runner

      slug_runner_opts = {
        'Image' => 'flynn/slugrunner',
        'OpenStdin' => true,
        'StdinOnce' => true,
        'ExposedPorts' => {
          '3000/tcp' => {}
        },
        'Env' => 'PORT=3000',
        'Entrypoint' => ['/runner/init', 'start web']
      }

      @slug_runner ||= Docker::Container.create(slug_runner_opts)
    end
end
