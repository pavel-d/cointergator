json.array!(@projects) do |project|
  json.extract! project, :id, :name, :description, :docker_options
  json.url project_url(project, format: :json)
end
