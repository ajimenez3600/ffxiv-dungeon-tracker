class Level < ApplicationRecord
  def self.total_xp(level, xp)
    Level.find_by_number(level).total_xp + xp
  end
end
