class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.admin?
      can :manage, :all
    else
      can :read, :all
      cannot :read, [Album, Category], hidden: true
    end
  end
end
