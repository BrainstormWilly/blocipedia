module CollaboratorsHelper

  def is_collaborator (wiki, user)
    return wiki.collaborators.where(user: user).exists?
  end

  def get_collaborator (wiki, user)
    return wiki.collaborators.where(user: user).first
  end

end
