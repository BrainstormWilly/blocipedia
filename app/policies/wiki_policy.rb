class WikiPolicy < ApplicationPolicy

  attr_reader :user, :wiki

  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end

  def show?
    user.admin? || !wiki.private || user==wiki.user
  end

  def update?
    index?
  end

  def edit?
    index?
  end

  def destroy?
    user.admin? || user==wiki.user
  end

  class Scope < Scope

    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.all
      else
        scope.where(private: false) || scope.where(user: user)
      end
    end
  end


end
