module WikisHelper

  def is_authorized_for_private()
    return !current_user.member?
  end

  def is_authorized_to_control(wiki)
    return wiki.user==current_user || current_user.admin?
  end

  def markdown(text)
    extensions = {
      fenced_code_blocks: true
    }
    renderer = Redcarpet::Render::HTML.new()
    markdown = Redcarpet::Markdown.new(renderer, extensions)
    markdown.render(text).html_safe
  end

end
