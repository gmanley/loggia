class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.admin? # Admin?
      can :manage, :all # Can do whatever they want.
    else # Guest or Registered user
      can :read, :all # Can read anything ...
      # except albums or categories that are private
      cannot :read, [Album, Category], hidden: true
      if user # registered user?
        # Can create and manage their own comments
        can :manage, Comment, user_id: user.id
        # Can favorite and unfavorite things
        can :manage, Favorite, user_id: user.id
      end
    end
  end
end