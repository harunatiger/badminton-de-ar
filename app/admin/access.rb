ActiveAdmin.register Access do
  index do
    Access.column_names.each do |col|
      column col
    end
    actions
  end
  
  csv :force_quotes => false do
    Access.column_names.each do |col|
      column col
    end
  end
end