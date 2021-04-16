class Metrics::TrialsController < ApplicationController
  def index
    @instance_entries = InstanceEntries.all.select { e| e.instance.instance_type == 'Trial' }
  end
end
