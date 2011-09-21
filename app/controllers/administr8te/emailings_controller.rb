class Administr8te::EmailingsController < Administr8te::BaseController
  set_tab :admin_emailings

  def index
    @emailings = Emailing.all
  end

  def show
    @emailing = Emailing.find(params[:id])
  end

  def new
    @emailing = Emailing.new
  end

  def edit
    @emailing = Emailing.find(params[:id])
  end

  def create
    @emailing = Emailing.new(params[:emailing])
    if @emailing.save
      redirect_to administr8te_emailings_path, notice: 'API entry was successfully created.'
    else
      render action: "new"
    end
  end

  def update
    @emailing = Emailing.find(params[:id])
    if @emailing.update_attributes(params[:emailing])
      redirect_to administr8te_emailings_path, notice: 'API entry was successfully updated.'

    else
      render action: "edit"
    end
  end

  def destroy
    @emailing = Emailing.find(params[:id])
    @emailing.destroy
    redirect_to administr8te_emailings_path
  end
end