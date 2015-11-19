ActiveAdmin.register Introduction do

  permit_params :code, :discount
  actions :all, except: [:edit]
  
  index do
    column :id
    column :code
    column :discount
    column :used_count do |obj|
      obj.reservations.accepts.count
    end
    column :used_total_price do |obj|
      sum = 0
      obj.reservations.accepts.map{|r| sum += r.amount}
      sum
    end
    column :created_at
    column :updated_at
    actions
  end
  
  form do |f|
    f.inputs do
      f.input :discount
    end
    f.actions
  end
end
