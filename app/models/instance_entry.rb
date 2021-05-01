class InstanceEntry < ApplicationRecord
  belongs_to :instance, dependent: :destroy
  belongs_to :job
  belongs_to :roulette, optional: true

  def total_xp
    Level.total_xp(finish_level, finish_xp) - Level.total_xp(start_level, start_xp)
  end

  def bonus_xp
    roulette_bonus + new_player_bonus + role_in_need_bonus + other_bonus
  end

  def combat_xp
    (total_xp - bonus_xp) / (100 + (xp_bonus || 0))
  end
end
