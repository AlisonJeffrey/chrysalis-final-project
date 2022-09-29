# require "http"
require "json"
require "open-uri"

class UsersController < ApplicationController
  skip_after_action :verify_authorized, only: :dashboard

  def dashboard
    @user_goals = policy_scope(UserGoal).group_by(&:description)
    @today_goals = UserGoal.where(user: current_user).where(created_at: Date.today.all_day) && UserGoal.where(status: "active")
    @recent_goals = UserGoal.where(user: current_user).order(created_at: :desc).first(5)
    @colors = ["blue", "green", "purple", "orange"]
    @emotions = current_user.emotions
    @emotion = current_user.emotions.where(created_at: Date.today.all_day)
    response = fetch_quotes
    @quotes = response[:quote]
    @author = response[:author]
    @articles = Article.where(title: "When Mental Illness Won't Let Us Leave The House")
    @header = true
    @journals = policy_scope(Journal)
    @journals = current_user.journals.where(created_at: Date.today.all_day)
  end

  def fetch_quotes
    url = "https://zenquotes.io/api/quotes"
    response = URI.open(url).read
    quotes_array = JSON.parse(response)
    { quote: quotes_array.first["q"], author: quotes_array.first["a"] }
  end
end
