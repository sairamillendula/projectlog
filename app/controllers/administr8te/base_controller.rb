class Administr8te::BaseController < ApplicationController
  before_filter :require_admin
  layout "administr8te"
end
