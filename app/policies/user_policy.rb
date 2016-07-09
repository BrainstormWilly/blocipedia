class UserPolicy < ApplicationPolicy

  attr_reader :user

  def initialize(user, wiki)
    @user = user
  end

  def show?
    user.admin? || user==current_user
  end

  def update?
    show?
  end

  def edit?
    show?
  end

  def destroy?
    user.admin?
  end

end
