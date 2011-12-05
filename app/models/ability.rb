class Ability
  include CanCan::Ability

  def initialize(user)

    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= User.new # Guest

    if user.admin?
      can :manage, :all
    else
      can :read, :all
    end
  end
end
