class ResourceDecorator < Draper::Decorator
  delegate_all

  %w{ name category unit }.each do |name|
    define_method("#{name}_body") do
      self.public_send(name).body
    end
  end

end
