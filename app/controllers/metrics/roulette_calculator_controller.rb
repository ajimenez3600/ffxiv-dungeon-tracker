class Metrics::RouletteCalculatorController < ApplicationController
  include Metrics::RouletteCalculatorHelper

  skip_before_action :verify_authenticity_token

  def new
    @roulettes = Roulette.where(grant_xp: true).map(&:name)
  end
  def create
    rq = JSON.parse(request.body.read)
    max_level = Level.all.pluck(:number).max
    roulettes = Roulette.all.to_a.keep_if { |r| rq['roulettes'].include? r.name }
    
    day = 1
    ordering = calculate_ordering(rq['start_level'].to_i, rq['start_xp'].to_i, roulettes)
    day_ordering = { day => ordering }
    return render json: day_ordering unless rq['to_max'].present? && !!rq['to_max']

    while max_level > ordering[:estimated_level]
      level = ordering[:estimated_level]
      xp = ordering[:estimated_xp]

      day += 1
      ordering = calculate_ordering(level, start_xp, roulettes)
      ordering[day] = ordering
    end

    render json: day_ordering
  end
end
