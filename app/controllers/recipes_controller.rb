class RecipesController < ApplicationController
  def index
    @recipes = Recipe.where(user_id: current_user.id)
  end

  def new
    @recipe = Recipe.new
  end

  def show
    @user = current_user
    @recipe = Recipe.find(params[:id])
    @recipe_foods = RecipeFood.where(recipe_id: @recipe.id)
    @foods = @recipe_foods.map(&:food)
  end

  def create
    @user = current_user
    @recipe = @user.recipes.new(recipe_params)

    if @recipe.save
      redirect_to recipe_path(@recipe), notice: 'The recipe was succesfuly created'
    else
      render :new, alert: 'The recipe was not created'
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    redirect_to recipe_path, notice: 'The recipe was deleted'
  end

  def public
    @recipes = Recipe.where(is_public: true).order(created_at: :desc)
    render 'public'
  end

  def public_toggle
    @recipe = Recipe.find(params[:id])
    @recipe.is_public = !@recipe.is_public
    @recipe.save
    redirect_to recipe_path(@recipe), notice: "The recipe is now #{@recipe.is_public ? 'public' : 'private'}"
  end

  def general_shopping_list
    @user = current_user
    @recipe = Recipe.find_by(id: params[:id])
    @recipe_foods = RecipeFood.where(recipe_id: @recipe.id)
    @needed_items = []
    @recipe_foods.each do |recipe_food|
      existed_food = @user.foods.find_by(name: recipe_food.food.name)
      if existed_food.nil?
        @needed_items << [recipe_food.food.name, recipe_food.quantity, recipe_food.food.price,
                          recipe_food.food.measurement_unit]
      else
        difference_quantity = recipe_food.quantity - existed_food.quantity
        if difference_quantity.positive?
          @needed_items << [recipe_food.food.name, difference_quantity, existed_food.price,
                            existed_food.measurement_unit]
        end
      end
    end
  end

  def recipe_params
    params.require(:recipe).permit(:name, :preparation_time_minutes, :cooking_time_minutes, :description, :is_public)
  end
end
