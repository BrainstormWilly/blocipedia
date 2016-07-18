class WikiPolicy < ApplicationPolicy

  attr_reader :user, :wiki

  def initialize(user, wiki)
    @user = user
    @wiki = wiki
  end

  def show?
    user.admin? || !wiki.private || (user.premium? && user==wiki.user) || wiki.users.include?(user)
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
      all_wikis = scope.all
      wikis = []
      if user.admin?
        wikis = scope.all
      elsif user.premium?
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.user == user || wiki.users.include?(user)
            wikis << wiki
          end
        end
      else
        all_wikis.each do |wiki|
          if !wiki.private? || wiki.users.include?(user)
            wikis << wiki
          end
        end
      end
      wikis
    end

  end


end
