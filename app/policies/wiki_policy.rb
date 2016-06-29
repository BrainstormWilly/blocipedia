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
      elsif user.member?
        scope.where(private: false)
      else
        scope.where("(private = 'f') or (user_id = #{@user.id})")
      end
    end
  end


end
