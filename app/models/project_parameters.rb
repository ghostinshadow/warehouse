class ProjectParameters
  include ActiveModel::Model
  attr_reader :name, :structure

  validates_presence_of :name

  def initialize(hsh = {})
    @name = hsh.fetch(:name)
    @structure = hsh.fetch(:structure, {})
    structure_check
    restructure
  end

  def to_attributes
    {name: name, structure: structure}
  end

  private

  def restructure
  	grouped = structure.group_by {|k, v| k.match(/_(\d+)/)[1] }
    @structure = grouped.inject({}) do |acc, (k, v)|
      id, number = v.map(&:last)
      acc[id] = number
      acc
    end
  end

  def structure_check
    @structure.delete_if do |k, v|
     !k.match(/resource_id_\d+?/) &&  !k.match(/resource_name_\d+?/)
   end
  end
end
