class Metrics::RouletteCalculatorController < ApplicationController
  include Metrics::RouletteCalculatorHelper

  skip_before_action :verify_authenticity_token

  def new
    @roulettes = Roulette.where(grant_xp: true).map(&:name)
  end
  def create
    rq = JSON.parse(request.body.read)
    puts rq['start_level'], rq['start_xp'], rq['roulettes']
    roulettes = Roulette.all.to_a.keep_if { |r| rq['roulettes'].include? r.name }
    render json: calculate_ordering(rq['start_level'].to_i, rq['start_xp'].to_i, roulettes)
  end
end
