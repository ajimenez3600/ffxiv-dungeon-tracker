class Metrics::RoulettesController < ApplicationController
  def index
    no_roulette = Roulette.find_by_name('No Roulette')
    @instance_entries = InstanceEntry.all
      .select { |e| e.roulette != no_roulette }
      .map { |e| { :level => e.start_level, :roulette => e.roulette.name, :roulette_bonus => e.roulette_bonus } }
      .sort_by { |e| e[:level] }
      .group_by { |e| e[:level] }
  end
end
