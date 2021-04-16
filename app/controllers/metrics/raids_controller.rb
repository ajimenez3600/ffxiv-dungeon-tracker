class Metrics::RaidsController < ApplicationController
  def index
    @instance_entries = InstanceEntries.all.select { e| e.instance.instance_type == 'Raid' }
  end
end
