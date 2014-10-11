class ContainersController < ApplicationController
  before_action :set_container, except: [:create]

  def create
    @container = Container.new container_params

    if @container.save
      flash[:notice] = 'Container created'
    end
    redirect_to project_path(params[:project_id])
  end

  def destroy
    if @container.destroy
      flash[:notice] = 'Container destroyed'
    end
    redirect_to project_path(params[:project_id])
  end

  private
    def set_container
      @container = Container.find(params[:id])
    end

    def container_params
      params.require(:container).permit(:branch_name).merge(project_id: params[:project_id])
    end
end
