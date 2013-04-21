class ActiveAdminAbility
  include CanCan::Ability

  def initialize(user)
    # Only admins can access active_admin
    if user && user.admin? # Admin?
      can :manage, :all # Can do whatever they want.
    else # Guest or Registered user
      cannot :read, :all
    end
  end
end
