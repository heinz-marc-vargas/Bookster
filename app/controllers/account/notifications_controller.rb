class Account::NotificationsController < ApplicationController
  before_filter :authenticate_user!
  layout :ajax_layout
  
  def index
  end
end
