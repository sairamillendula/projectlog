class PagesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_user
  set_tab :dashboard

end
