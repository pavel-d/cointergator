class RepositoriesController < ApplicationController
  before_action :set_project
  def create
    if @project.create_repository repository_params
      flash[:notice] = 'Application cloned'
    end
    redirect_to @project
  end

  def pull
    @project.repository.pull
    flash[:notice] = 'Repository updated'
    redirect_to @project
  end

  private
    def set_project
      @project = Project.find params[:project_id]
    end

    def repository_params
      params.permit(:repository).require(:remote_url)
    end
end
