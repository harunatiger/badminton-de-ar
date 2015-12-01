require 'csv'

Category.delete_all
Category.connection.execute("SELECT SETVAL('categories_id_seq',1,FALSE)")
CSV.foreach('db/seeds_data/categories.csv') do |row|
  Category.create(name: row[0])
end

Language.delete_all
Language.connection.execute("SELECT SETVAL('languages_id_seq',1,FALSE)")
CSV.foreach('db/seeds_data/languages.csv') do |row|
  Language.create(name: row[0])
end