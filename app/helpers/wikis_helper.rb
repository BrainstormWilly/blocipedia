module WikisHelper
  def is_authorized_for_private()
    return !current_user.member?
  end
end
