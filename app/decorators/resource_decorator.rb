class ResourceDecorator < Draper::Decorator
  delegate_all

  %w{ name category unit }.each do |name|
    define_method("#{name}_body") do
      word = self.public_send(name) || NoWord.new
      word.body
    end
  end

end
