class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    can :read, [ CaseStudy, Language, Link, Moment, Page, Photo, Timeline ]
    can :read, [ Document ], :restricted => false
    can :manage, user

    if user.has_role? :admin
      can :manage, :all
    elsif user.has_role?(:volunteer) || user.has_role?(:staff)
      can :read, [ Document, Reference, Region, Revision, Stage, Sector, User, Volunteer, Unit, WorkZone ]
      can :create, [ CaseStudy, Document, Link, Moment, Page, Photo, Revision ]
      can :manage, Volunteer, :user_id => user.id if user.has_role?(:volunteer)
      can :manage, Staff, :user_id => user.id if user.has_role?(:staff)
    end

    if user.has_role? :moderator
      can :manage, [CaseStudy, Document, Language, Link, Moment, Page, Photo, Region, Revision, Role, Sector, Stage, Timeline, ValidEmail, WorkZone]
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
