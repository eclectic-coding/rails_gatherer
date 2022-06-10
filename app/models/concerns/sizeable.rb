# frozen_string_literal: true

module Sizeable
  extend ActiveSupport::Concern

  def small?
    size <= 1
  end

  def epic?
    size >= 5
  end
end
