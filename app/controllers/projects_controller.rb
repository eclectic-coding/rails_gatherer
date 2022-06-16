# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :find_project, only: :show
  
  def index
    @projects = Project.all
  end

  def show
  end

  def new
    @project = Project.new
  end

  def create
    @workflow = CreatesProject.new(
      name: params[:project][:name],
      task_string: params[:project][:tasks]
    )
    @workflow.create
    if @workflow.success?
      redirect_to projects_path
    else
      @project = @workflow.project
      render :new
    end
  end
  
  private 
  
  def find_project
    @project = Project.find(params[:id])
  end
end
