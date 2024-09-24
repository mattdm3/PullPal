# Responsible for handling provider sessions 
class SessionsController < ApplicationController
    def create
        # Extract Auth data from OmniAuth
        auth = request.env['omniauth.auth']

        # Dynamically handle different providers (github, gitlab, etc)
        user = find_or_create_user(auth)

        # Log the user in by storing the user ID in the session 
        session[:user_id] = user.id  

        Rails.logger.debug "User: #{user.inspect}"

        Rails.logger.debug "Session user_id after login: #{session[:user_id]}"

        # Redirect after succesful login
        redirect_to dashboard_path, notice: "Succesfully logged in with #{auth['provider']}!"
    end

    def destroy 
        # Log out by clearing session
        session[:user_id] = nil
        redirect_to root_path, notice: "Successfully logged out!"
    end

    private 

    # handles finding or creating users based on OAuth Data
    def find_or_create_user(auth)
        # Use both provider and uid to uniquely identify the user across
        Rails.logger.debug "INITIALIZING github id: #{auth.inspect}"
        user = User.find_or_initialize_by(provider: auth['provider'], uid: auth['uid']) do |user|
            user.username = auth['info']['nickname'] || auth['info']['name']
            user.email = auth['info']['email']
            user.github_id = auth['uid'] # GitHub ID
            user.avatar_url = auth['info']['image']
            user.name = auth['info']['name']
             # Only set GitHub token if the provider is GitHub
            if auth['provider'] == 'github'
                user.github_token = auth['credentials']['token']
            elsif auth['provider'] == 'gitlab'
                user.gitlab_token = auth['credentials']['token']
            end
            # user.gitlab_token = auth['credentials']['token'] if auth['provider'] == 'gitlab'
            
        end
        # Save the user if it's a new record
        if user.new_record?
            if user.save
            Rails.logger.debug "New user saved: #{user.inspect}"
            else
            Rails.logger.debug "Failed to save new user: #{user.errors.full_messages}"
            end
        else
            Rails.logger.debug "Existing user found: #{user.inspect}"
        end

        user
    end
end