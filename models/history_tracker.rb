require_relative "base_model"

module Devcasts
  module Models
    class HistoryTracker
      include Mongoid::History::Tracker
    end
  end
end
