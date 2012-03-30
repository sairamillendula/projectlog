class Administr8te::DashboardController < Administr8te::BaseController
  set_tab :admin_dashboard
  def show
    @recently_online_users = User.standard.recently_online
  end
end
