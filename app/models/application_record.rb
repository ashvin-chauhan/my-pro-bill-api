class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def parse_date(date)
    Date.strptime(date, "%m/%d/%Y").to_datetime
  end
end
