require 'csv'

i = 1
CSV.foreach('db/seeds_data/categories.csv') do |row|
  category = Category.where(id: i).first
  if category
    category.update(name: row[0])
  else
    Category.create(name: row[0])
  end
  i += 1
end

i = 1
CSV.foreach('db/seeds_data/languages.csv') do |row|
  language = Language.where(id: i).first
  if language
    language.update(name: row[0])
  else
    Language.create(name: row[0])
  end
  i += 1
end

i = 1
CSV.foreach('db/seeds_data/options.csv') do |row|
  option = Option.where(id: i).first
  if option
    option.update(name: row[0], type: row[1])
  else
    Option.create(name: row[0], type: row[1])
  end
  i += 1
end
