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
  def combat_and_bonus_xp
    bonus_xp + combat_xp
  end

  def minutes_to_queue_pop
    (queue_pop_time - start_time) / 60
  end
  def minutes_to_finish
    (finish_time - start_time) / 60
  end
  def minutes_in_instance
    (finish_time - queue_pop_time) / 60
  end
end
