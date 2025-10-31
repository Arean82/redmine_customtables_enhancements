class CustomTableEnhancementsController < ApplicationController
  layout 'admin'
  before_action :require_admin

  def index
    @tables = CustomTables::CustomTable.all.includes(:custom_fields)
  end

  def edit
    @table = CustomTables::CustomTable.find(params[:id])
    @enhancement = CustomTableEnhancement.find_or_initialize_by(custom_table_id: @table.id)
  end

  def update
    @table = CustomTables::CustomTable.find(params[:id])
    @enhancement = CustomTableEnhancement.find_or_initialize_by(custom_table_id: @table.id)
    if @enhancement.update(enhancement_params)
      flash[:notice] = l(:notice_successful_update)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def settings
    @table = CustomTables::CustomTable.find(params[:table_id])
    enh = CustomTableEnhancement.find_by(custom_table_id: @table.id)
    render json: enh || {}
  end

  private

  def enhancement_params
    params.require(:custom_table_enhancement).permit(
      auto_populate_fields: [], read_only_fields: [],
      :enable_journaling, :capture_author_date
    )
  end
end
