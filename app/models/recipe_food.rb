class RecipeFood < ApplicationRecord
  # Associations
  belongs_to :food, class_name: 'Food', foreign_key: 'recipe_id'
  belongs_to :recipe, class_name: 'Recipe', foreign_key: 'food_id'

  # Attributes
  attribute :quantity, :integer

  # Callbacks

  # Validations

  # Mehtods
end
