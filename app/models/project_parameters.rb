class ProjectParameters
  include ActiveModel::Model

  validates_presence_of :name
  validates :structure_check

  def initialize(hsh = {})
    @name = hsh.fetch(:name)
    @structure = {}
    binding.pry
  end

  private

  def structure_check
  end
end


  

  attr_reader :date, :type_id, :buildings, :tags, :hdd_edge

  validates_presence_of :date, :type_id, :buildings, message: I18n.t('all_fildz')

  def initialize(hsh={})
    @date = hsh[:analysis_date].try(:to_date)
    @type_id = hsh[:type_id]
    @tags = hsh[:tags]
    @buildings = hsh[:buildings]
    @hdd_edge = hsh.fetch(:hdd_edge, HDD_CONST)
  end

  def error_messages
    errors.messages.inject({}){|acc, (k,v)| acc[I18n.t("incoming_orders.#{k}")] = v; acc }
  end