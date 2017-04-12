class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.has_role?(:admin)
      can :manage, :all
    elsif user.has_role?(:user)
      can :read, :all

      can :manage, Project
      cannot :update, Project

      can :update, Dictionary

      can [:create, :update], DailyCurrency

      can :create, Shipping

      can [:create, :update], Resource

      can [:create, :update], Word
    end
  end
end