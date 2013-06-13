class Ability
  include CanCan::Ability

  def initialize(current_user)
    @user = current_user ||= User.new # guest user (not logged in)

    send(@user.role)
  end

  def admin
    can :manage, :all
  end

  def owner
    unless @user.companies.empty?
      can :read,   Company
      can :update, Company, :id => @user.company_ids

      can :read,   Branch
      can :manage, Branch, :id => @user.branch_ids

      can :manage, Staff
      can :manage, Review

      can :read,   Customer

      can :read,   Service
      can :manage, Service, :id => @user.service_ids
      
      can :read,   Event
      can :manage, Event, :id => @user.event_ids
      
      can :manage, :Review
    end
  end
  
  def staff
    can :read,   Event
    can :read,   Customer
    can :update, Customer
    can :read,   Staff
    can :update, Staff, :id => @user.resource_id
  end
  
  def customer
    can :read, Event 
    can :read, Review
  end
  
end
