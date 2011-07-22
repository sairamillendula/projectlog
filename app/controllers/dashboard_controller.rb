class DashboardController < ApplicationController
  before_filter :authenticate_user!  
  set_tab :dashboard
end
