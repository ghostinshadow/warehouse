class ActivityDecorator < Draper::Decorator
  delegate_all

  def render_activity
    "#{user.email}" + " " + render_partial
  end

  def trackable_name
    object.trackable_type.underscore
  end

  def render_partial
    locals = {activity: object, presenter: self}
    assign_object_to_locals(locals)
    h.render partial: partial_path, locals: locals
  end

  def partial_path
    "activities/#{trackable_name}/#{object.action}"
  end

  def self.collection_decorator_class
    PaginatingDecorator
  end

  private

  def assign_object_to_locals(locals)
    if trackable
      locals[trackable_name.to_sym] = trackable.decorate
    else
      locals[trackable_name.to_sym] = nil
    end
  end
end
