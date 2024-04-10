class ProductsController < ApplicationController
  def index
    @products = Product.all
    # el @ me indica que mi varible es una variable de instancia
  end

  def show
    @product = Product.find(params[:id])
  end
  
end
