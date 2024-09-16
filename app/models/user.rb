class User < ApplicationRecord 
    validates :username, uniqueness: true
    validates :email, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP}
    validates :github_token, uniqueness: true
    validates :github_id, presence: true
    
    # Additional Fields
    validates :name, presence: true
    validates :avatar_url, presence: true
    
    # Callbacks: Placeholder for future GitHub repository fetching logic
    # after_create :fetch_github_repositories

end