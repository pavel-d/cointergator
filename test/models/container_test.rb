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

require 'test_helper'

class ContainerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
