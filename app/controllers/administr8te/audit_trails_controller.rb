class Administr8te::AuditTrailsController < Administr8te::BaseController
  set_tab :admin_audit
  
  def index
    @audit_trails = AuditTrail.search(params[:search]).order('created_at DESC').page(params[:page]).per(20) 
  end

end