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

require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
