class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Attachment]
    can [:update, :destroy], [Question, Answer], user_id: user.id
    can :edit, [Question, Answer]

    can :create, Subscription do |subscription|
      !subscription.question.subscribed_by?(user)
    end
    can :create, Subscription

    alias_action :vote_up, :vote_down, :vote_reset, to: :votes
    can :votes, [Question, Answer] do |type|
      type.user.author_of?(type)
    end

    can :set_best, Answer do |answer|
      user.author_of?(answer.question)
    end

    can :destroy, Attachment do |attach|
      attach.attachable.user_id == user.id
    end

    can :destroy, Subscription, user_id: user.id

    can :comment, [Question, Answer]

    can :manage, :profile
  end
end
