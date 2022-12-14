class UserGoalPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.where(user: user)
    end
  end

  def new?
    true
  end

  def create?
    new?
  end

  def update
    true
  end

  def dashboard?
    record.user == user
  end
end
