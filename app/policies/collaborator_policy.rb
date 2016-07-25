class CollaboratorPolicy < ApplicationPolicy

  attr_reader :user, :collaborator

  def initialize(user, collaborator)
    @user = user
    @collaborator = collaborator
  end

  def create?
    user.admin? || (user.premium? && collaborator.wiki.user == user)
  end

  def destroy?
    create?
  end


  class Scope < Scope

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      users = []
      if user.admin? || user.premium?
        users = User.where.not(id: user.id)
      end
      users
    end

  end


end
