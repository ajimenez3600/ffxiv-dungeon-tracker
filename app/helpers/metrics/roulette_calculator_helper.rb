module Metrics::RouletteCalculatorHelper
  def calculate_ordering(start_level, start_xp, roulettes)
    total_xp = Level.total_xp(start_level, start_xp)
    roulette_xp = roulettes.map do |roulette|
      {
        roulette: roulette,
        name: roulette.name,
        predicted_xp: get_xp_for_roulette(roulette, start_level),
        next_level_xp: get_xp_for_roulette(roulette, start_level + 1)
      }
    end

    xp_to_next = (Level.total_xp(start_level + 1) * 1.03) - total_xp # buffer xp to next by a bit
    puts "xp to next: #{xp_to_next} | predicted xp: #{roulette_xp.map { |r| r[:predicted_xp] }.sum}"
    if roulette_xp.map { |r| r[:predicted_xp] }.sum > xp_to_next then
      best_set = powerset!(roulette_xp)
        .keep_if { |s| s.map { |r| r[:predicted_xp] }.sum > xp_to_next }
        .sort_by { |s| s.map { |r| r[:next_level_xp] }.sum }
        .reverse
        .first

      estimated_total_xp = total_xp + best_set.map { |r| r[:predicted_xp] }.sum
      estimated_level = Level.get_level(estimated_total_xp)
      estimated_xp = estimated_total_xp - Level.total_xp(estimated_level)
      remaining_roulettes = roulettes - best_set.map { |r| r[:roulette] }

      return { start_level => scrub_db_info(this_level) }
        .merge(calculate_ordering(estimated_level, estimated_xp, remaining_roulettes))
    else
      return { start_level => scrub_db_info(roulette_xp) }
    end
  end

  def get_xp_for_roulette(roulette, start_level)
    entries = InstanceEntry.where(start_level: start_level, roulette: roulette)
    return 0 if entries.count == 0

    entries.sum { |e| e.bonus_xp + e.combat_xp } / entries.count
  end

  private

  def scrub_db_info(roulette_xp)
    roulette_xp.each { |r| r.except!(:roulette) }
  end

  def powerset!(set)
    return [set] if set.empty?

    p = set.pop
    subset = powerset!(set)
    subset | subset.map { |x| x | [p] }
  end
end