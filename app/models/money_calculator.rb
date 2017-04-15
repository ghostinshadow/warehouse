class MoneyCalculator
  attr_reader :project_prototype_id
  attr_accessor :sum

  def initialize(hsh = {})
    @project_prototype_id = hsh.fetch(:project_prototype_id)
    @sum = Hash.new{ |h, k| h[k] = 0 }
    calculate_sum
  end

  def project_prototype
    ProjectPrototype.find(project_prototype_id)
  end

  def last_currency
    DailyCurrency.order(valid_on: :desc).limit(1) || NoDailyCurrency.new
  end

  def display_currency(sym)
  	"#{sum[sym]} #{currency_symbols[sym]}"
  end

  def currency_symbols
  	DailyCurrency.currency_symbols
  end

  private

  def calculate_sum
    iterator = project_prototype.enum_for(:each)
    iterator.inject(sum) do |acc, (resource, value)|
      [:uah, :usd, :eur].each do |currency|
        acc[currency] += resource.public_send("price_#{currency}") * BigDecimal(value)
      end
      acc
    end
  end

end
