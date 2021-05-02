module Metrics::RouletteCalculatorHelper
  def calculate_ordering(start_level, start_xp, roulettes)
    total_xp = Level.total_xp(start_level, start_xp)
    roulette_xp = roulettes.map do |roulette|      
      { roulette: roulette, name: roulette.name, predicted_xp: get_xp_for_roulette(roulette, start_level) }
    end

    xp_to_next = Level.total_xp(start_level + 1) * 1.03 # buffer xp to next by a bit
    return { start_level => scrub_db_info(roulette_xp) } if roulette_xp.map { |r| r[:predicted_xp] }.sum < xp_to_next

    this_level = powerset!(roulette_xp)
      .map { |s| { data: s, sum: s.map(&:predicted_xp).sum } }
      .keep_if { |s| s.sum < xp_to_next }
      .sort_by { |s| sum }
      .first

    predicted_total_xp = total_xp + this_level.sum
    predicted_level = Level.get_level(predicted_total_xp)
    predicted_xp = predicted_total_xp - Level.total_xp(predicted_level)
    available_roulettes = roulettes - this_level.map(&:roulette)

    this_level = this_level.map { |r| { name: r.name, predicted_xp: r.predicted_xp } }
    { start_level => scrub_db_info(this_level) }.merge(calculate_ordering(predicted_level, predicted_xp, available_roulettes))
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