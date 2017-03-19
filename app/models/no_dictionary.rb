class NoDictionary
  [:words, :options].each do |sym|
    define_method(sym){ [] }
  end
end