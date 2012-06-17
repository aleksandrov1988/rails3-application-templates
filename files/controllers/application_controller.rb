# coding : utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :check_auth
  before_filter :check_authentication

  private

  def check_auth
    unless request.format.js?
      CASClient::Frameworks::Rails::Filter.filter(self)
    end
  end

  def check_authentication
    @current_user=User.find_by_login(session[:cas_user]) unless session[:cas_user].blank?
    unless @current_user
      @error="Пользователь не найден"
      respond_to do |format|
        format.html { render :text => @error }
        format.js { render :js => "#{@error}" }
      end
    end
  end

  def current_login
    session[:cas_user]
  end
end
