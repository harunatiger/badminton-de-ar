class ProfilePercentage < ActiveHash::Base
  field :name
  add :id => 1, :name => "US"
  add :id => 2, :name => "Canada"
  
end