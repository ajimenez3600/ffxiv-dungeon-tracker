class Level < ApplicationRecord
  def self.total_xp(level, xp = 0)
    Level.find_by_number(level).total_xp + xp
  end
  def get_level(xp)
    Level.where(total_xp: xp..).map(&:number).min
  end
end
