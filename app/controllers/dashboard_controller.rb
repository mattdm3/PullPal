class DashboardController < ApplicationController 
    before_action :require_login

    def index
   # dash content for logged in users
    end

    private

    def require_login
        unless current_user
            Rails.logger.debug "User is not logged in! Redirecting to root."
            redirect_to login_path, alert: "You must be logged in to access the dashboard."
        else
            Rails.logger.debug "User is logged in as #{current_user.username}."
        end
    end
end