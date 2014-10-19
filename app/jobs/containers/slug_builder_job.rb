require 'rubygems/package'

class Containers::SlugBuilderJob < ActiveJob::Base
  queue_as :default

  def perform(container)

    stream_archive(container) do |archive|
      # TODO: Save output log somewhere in DB
  		slug_builder.tap(&:start).attach(stdin: archive)  
	  end

    slug_builder.wait

    save_slug container

    Containers::SlugRunnerJob.perform_later container
  end

  private

    def slug_builder
      slug_runner_opts = {
        'Image' => 'flynn/slugbuilder',
        'OpenStdin' => true,
        'StdinOnce' => true
      }

      @slug_runner ||= Docker::Container.create(slug_runner_opts)
    end

    def stream_archive(container)
      raise ArgumentError, "Missing block" unless block_given?

      cmd = "cd #{container.repository.local_path} && git archive #{container.branch_name}"
      IO.popen(cmd) do |archive|
        yield archive
      end
    end

    def extract_tar(tar_file_name, destination)
      File.open(tar_file_name, 'r') do |tar_file|
        Gem::Package::TarReader.new tar_file do |tar|
          tar.each do |entry|
            File.open destination, 'wb' do |f|
              f.write entry.read
            end
          end
        end
      end
    end

    def save_slug(container)
      FileUtils.mkdir_p container.slug_dir

      # Docker exports slug.tgz is wrapped in another tar archive.
      # Sorry for that...
      temp_tar_name = container.slug_dir + '/exported.tar'

      File.open temp_tar_name, 'wb' do |tar_file|
        slug_builder.copy('/tmp/slug.tgz') { |chunk| tar_file.write chunk }
      end

      extract_tar temp_tar_name, container.slug_path
      File.delete temp_tar_name
    end
end
