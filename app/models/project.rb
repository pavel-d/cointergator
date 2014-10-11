# == Schema Information
#
# Table name: projects
#
#  id             :integer          not null, primary key
#  name           :string
#  description    :text
#  docker_options :string
#  repository_id  :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Project < ActiveRecord::Base
  has_one  :repository, dependent: :destroy
  has_many :containers, dependent: :destroy
  accepts_nested_attributes_for :repository
end
