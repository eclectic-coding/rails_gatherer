require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:project) { Project.new }
  let(:task) { Task.new }

  it "considers a project with no tasks to be done" do
    expect(project.done?).to be_truthy
  end

  it "knows that a project with an incomplete task is not done" do
    project.tasks << task
    expect(project.done?).to be_falsey
  end

  it "marks a project done if its task are done" do
    project.tasks << task
    task.mark_completed
    expect(project).to be_done
  end
end
