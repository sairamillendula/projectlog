class Administr8te::DashboardController < ApplicationController
  before_filter :require_admin
  def show
  end
end
