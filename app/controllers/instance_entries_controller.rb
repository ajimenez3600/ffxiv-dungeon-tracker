class InstancesController < ApplicationController

  # GET /instances/new
  def new
    @instance = Instance.new
    @jobs = ['dragoon', 'scholar']
    @instances = [ { name: 'Dungeons (ARR)', instances: [ 'Castrum Meridianum', 'The Praetorium'] }, { name: 'Trials (ARR)', instances: ['The Navel (Hard)' ] } ]
  end

  # POST /instances or /instances.json
  def create
    @instance = Instance.new(instance_params)

    respond_to do |format|
      if @instance.save
        format.html { redirect_to @instance, notice: "Instance was successfully created." }
        format.json { render :show, status: :created, location: @instance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    # Only allow a list of trusted parameters through.
    def instance_params
      puts params
      params.require(:instance).permit(:create)
    end
end
