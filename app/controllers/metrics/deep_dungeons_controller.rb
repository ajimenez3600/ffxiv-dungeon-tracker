class Metrics::DeepDungeonsController < ApplicationController
  def index
    @instance_entries = InstanceEntries.all.select { e| e.instance.instance_type == 'Deep Dungeon' }
  end
end
