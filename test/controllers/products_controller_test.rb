require 'test_helper'
class ProductControllerTest < ActionDispatch::IntegrationTest

  test 'render a list of products' do
    get products_path

    assert_response :success
    assert_select '.product', 3
  end

    test 'render a detailed product page' do
      get product_path(products(:ps4))

      assert_response :success
      assert_select '.title', 'PS4 Fat'
      assert_select '.description', 'PS4 en buen estado'
      assert_select '.price', '150$'

    end

  test 'render a new product form' do
    get new_product_path

    assert_response :success
    assert_select 'form'
  end

  test 'allows to create a new product' do
    post products_path, params: {
      product: {
        title: 'Laptops Alienware',
        description: 'Le faltan unas teclas',
        price: 490,
        category_id: categories(:computers).id
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha creado correctamente'
  end

  test 'does not allow to create a new product with empty fields' do
    post products_path, params: {
      product: {
        title: '',
        description: 'Le faltan unas teclas',
        price: 490
      }
    }

    assert_response :unprocessable_entity
  end

  test 'render a edit product form' do
    get edit_product_path(products(:switch))

    assert_response :success
    assert_select 'form'
  end

  test 'allow to update a new product' do
    patch product_path(products(:ps4)), params: {
      product: {
        price: 165,
      }
    }

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha actualizado correctamente'
  end

  test 'not allow to update a new product with an invalid field' do
    patch product_path(products(:ps4)), params: {
      product: {
        price: nil,
      }
    }

    assert_response :unprocessable_entity
  end

  test 'can delete products' do
    assert_difference('Product.count', -1) do
      delete product_path(products(:ps4))
    end

    assert_redirected_to products_path
    assert_equal flash[:notice], 'Tu producto se ha eliminado correctamente'
  end

  test 'render a list of products filtered by min_price and max_price' do
    get products_path(min_price: 160, max_price: 200)

    assert_response :success
    assert_select '.product', 1
    assert_select 'hw3', 'Nintendo Switch'
  end

  test 'search a product by query_text' do
    get products_path(query_text: 'Switch')

    assert_response :success
    assert_select '.product', 1
    assert_select 'h3', 'Nintendo Switch'
  end
end
