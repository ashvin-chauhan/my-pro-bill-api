class TimeLog < ApplicationRecord
  acts_as_paranoid

  # Assoviations
  belongs_to :time_tracker
end
