class Metrics::DungeonsController < ApplicationController
  def index
    @instance_entries = InstanceEntries.all.select { e| e.instance.instance_type == 'Dungeon' }
  end
end
