require 'csv'

CSV.foreach('db/seeds_data/categories.csv') do |row|
  Category.create(name: row[0])
end

CSV.foreach('db/seeds_data/languages.csv') do |row|
  Language.create(name: row[0])
end