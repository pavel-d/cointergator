class ProjectsController < ApplicationController
  before_action :set_project, except: [:index, :create, :new]

  def index
    @projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
    @project.build_repository
  end

  def edit
  end

  def create
    @project = Project.new(project_params)

    puts @project.inspect

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy
    respond_to do |format|
      format.html { redirect_to projects_url, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_project
      @project = Project.find(params[:id])
    end


    def project_params
      params.require(:project).permit(:name, :description, :docker_options, repository_attributes: [:remote_url])
    end
end