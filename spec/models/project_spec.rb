require 'rails_helper'

RSpec.describe Project do

  it_behaves_like 'sizeable'

  describe 'completion' do

    describe 'without a task' do
      let(:project) { build_stubbed(:project) }

      it 'considers a project with no tasks to be done' do
        expect(project).to be_done
      end

      it 'properly estimates a blank project' do
        expect(project.completed_velocity).to eq(0)
        expect(project.current_rate).to eq(0)
        expect(project.projected_days_remaining).to be_nan
        expect(project).not_to be_on_schedule
      end
    end

    describe 'with a task' do
      let(:project) { build_stubbed(:project, tasks: [task]) }
      let(:task) { build_stubbed(:task) }

      it 'knows that a project with an incomplete task is not done' do
        expect(project).not_to be_done
      end

      it 'marks a project done if its tasks are done' do
        task.mark_completed
        expect(project).to be_done
      end
    end

  end

  describe 'estimates' do
    let(:project) { build_stubbed(:project, tasks: [newly_done, old_done, small_not_done, large_not_done]) }
    let(:newly_done) { build_stubbed(:task, :newly_complete) }
    let(:old_done) { build_stubbed(:task, :long_complete, :small) }
    let(:small_not_done) { build_stubbed(:task, :small) }
    let(:large_not_done) { build_stubbed(:task, :large) }

    it 'can calculate total size' do
      expect(project).to be_of_size(10)
      expect(project).not_to be_of_size(5)
    end

    it 'can calculate remaining size' do
      expect(project).to be_of_size(6).for_incomplete_tasks_only
    end

    it 'knows its velocity' do
      expect(project.completed_velocity).to eq(3)
    end

    it 'knows its rate' do
      expect(project.current_rate).to eq(1.0 / 7)
    end

    it 'knows its projected time remaining' do
      expect(project.projected_days_remaining).to eq(42)
    end

    it 'knows if it is not on schedule' do
      project.due_date = 1.week.from_now
      expect(project).not_to be_on_schedule
    end

    it 'knows if it is on schedule' do
      project.due_date = 6.months.from_now
      expect(project).to be_on_schedule
    end
  end

  describe 'task order' do
    let(:project) { create(:project, name: 'Project') }

    it "makes 1 the order of the first task in an entry project" do
      expect(project.next_task_order).to eq(1)
    end
  end

  describe 'stubs' do
    it 'stubs an object' do
      project = described_class.new(name: 'Project Greenlight')
      allow(project).to receive(:name)
      expect(project.name).to be_nil
    end

    it 'stubs an object again' do
      project = described_class.new(name: 'Project Greenlight')
      allow(project).to receive(:name).and_return('Fred')
      expect(project.name).to eq('Fred')
    end

    it 'stubs a class' do
      allow(described_class).to receive(:find).and_return(
        described_class.new(name: 'Project Greenlight')
      )
      project = described_class.find(1) # Avoid stubbing find (p.136)
      expect(project.name).to eq('Project Greenlight')
    end

    it 'mocks an object' do
      mock_project = described_class.new(name: 'Project Greenlight')
      allow(mock_project).to receive(:name).and_return('Fred')
      expect(mock_project.name).to eq('Fred')
    end
  end

end
