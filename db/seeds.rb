require 'csv'

CSV.foreach('db/seeds_data/categories.csv') do |row|
  Category.create(name: row[0])
end