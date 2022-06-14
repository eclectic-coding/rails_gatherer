# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Task, type: :model do
  it_behaves_like 'sizeable'

  describe 'initialization' do
    let(:task) { described_class.new }

    it 'does not have a new task as complete' do
      expect(task).not_to be_complete
    end

    it 'allows us to complete a task' do
      task.mark_completed
      expect(task).to be_complete
    end

    it 'stubs with multiple return values' do
      task = described_class.new
      allow(task).to receive(:size).and_return(1, 2)
      assert_equal(1, task.size)
      assert_equal(2, task.size)
      assert_equal(2, task.size)
    end
  end

  describe 'velocity' do
    let(:task) { described_class.new(size: 3) }

    it 'does not count an incomplete task toward velocity' do
      expect(task).not_to be_a_part_of_velocity
      expect(task.points_toward_velocity).to eq(0)
    end

    it 'counts a recently completed task toward velocity' do
      task.mark_completed(1.day.ago)
      expect(task).to be_a_part_of_velocity
      expect(task.points_toward_velocity).to eq(3)
    end

    it 'does not count a long-ago completed task toward velocity' do
      task.mark_completed(6.months.ago)
      expect(task).not_to be_a_part_of_velocity
      expect(task.points_toward_velocity).to eq(0)
    end
  end
end
