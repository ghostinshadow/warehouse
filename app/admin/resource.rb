ActiveAdmin.register Resource do

permit_params :name_id, :category_id, :unit_id, :type, :price_uah, :price_usd, :price_eur

end
