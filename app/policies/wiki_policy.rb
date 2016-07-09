class WikiPolicy < ApplicationPolicy

  attr_reader :user, :wiki

  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end

  def show?
    user.admin? || !wiki.private || (user.premium? && user==wiki.user)
  end

  def create?
    user.admin? || (!wiki.private && user==wiki.user) || (user.premium? && user==wiki.user)
  end

  def update?
    show?
  end

  def edit?
    show?
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
      if user.admin?
        scope.all
      elsif user.member?
        scope.where(private: false)
      elsif user.premium?
        scope.where("(private = 'f') or (user_id = #{@user.id})")
      end
    end
  end


end
