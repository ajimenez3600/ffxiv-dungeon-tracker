class InstanceEntriesController < ApplicationController

  def new
    @instance_entry = InstanceEntry.new
    @jobs = ['dragoon', 'scholar']
    @instances = [ { name: 'Dungeons (ARR)', instances: [ 'Castrum Meridianum', 'The Praetorium'] }, { name: 'Trials (ARR)', instances: ['The Navel (Hard)' ] } ]
  end

  def create
    @instance_entry = InstanceEntry.new(instance_entry_params)

    respond_to do |format|
      if @instance_entry.save
        format.html { redirect_to @instance_entry, notice: "Instance was successfully created." }
        format.json { render :show, status: :created, location: @instance_entry }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @instance_entry.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def instance_entry
      puts params
      params.require(:instance_entry).permit(:create)
    end
end
