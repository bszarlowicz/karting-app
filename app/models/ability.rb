# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    can [:index], Track

    if user
      can [:show], Lap, user_id: user.id
      can [:index, :show], Race
      can [:index, :show], Track
      can :manage, User, id: user.id

      if user.admin?
        can :manage, :all
      end
    end
  end

end
