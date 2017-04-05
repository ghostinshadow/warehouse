class ProjectPrototypeDecorator < Draper::Decorator
  delegate_all

  def resources
    structure.inject([]) do |acc, (k, v)|
      resource = Resource.find_by(id: k).decorate
      acc << [resource.full_name, resource.display_value(v)]
    end
  end

end
