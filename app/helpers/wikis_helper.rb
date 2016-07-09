module WikisHelper
  def is_authorized_for_private()
    return !current_user.member?
  end
  def is_authorized_to_delete(wiki)
    return wiki.user==current_user || current_user.admin?
  end
end
