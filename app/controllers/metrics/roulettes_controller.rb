class Metrics::RoulettesController < ApplicationController
  def index
    @instance_entries = InstanceEntries.all.select { e| !e.roulette_name.blank? }
  end
end
