class Ability
  include CanCan::Ability

  def initialize user
    can :read, [Product, Comment]

    return unless user.present?
    can :manage, Comment, user_id: user.id
    if user.admin?
      can :manage, :all
      cannot :update, Comment do |comment|
        comment.user_id != user.id
      end
    else
      can :manage, User, id: user.id
      can [:create, :read, :destroy], Order, user_id: user.id
      cannot :destroy, Order, user_id: user.id, status: :approved
      can :create, Suggestion
    end
  end
end
