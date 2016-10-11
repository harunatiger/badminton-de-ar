ActiveAdmin.register Access do
  index do
    Access.column_names.each do |col|
      column col
    end
    actions
  end
end