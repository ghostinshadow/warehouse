module ApplicationHelper

  def tab_class_for(namespace)
    (params[:controller] == namespace) ? 'active nav-link' : 'nav-link'
  end
end
