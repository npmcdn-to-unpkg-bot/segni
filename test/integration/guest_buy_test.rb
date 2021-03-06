require 'test_helper'

class GuestBuyTest < ActionDispatch::IntegrationTest
  
  setup do
    website = websites(:website_one)
    host! "#{website.name_slug}.example.com"
  end

  test "user can see the product" do
    get product_path(id: products(:product_one).id, locale: 'it')
    assert_response :success
    assert assigns  :product
  end

  test "user can put in the cart the product" do
    @product = products(:product_one)
    put_item_in_cart @product
    
    assert_redirected_to shopping_cart_path
    
    cart = assigns(:shopping_cart)
    item = cart.shopping_cart_items.take.item
    
    assert_equal item, @product
  end

  test "user can change quantity of product" do
    @product = products(:product_one)
    put_item_in_cart @product
    post "/it/shopping_cart/up/#{@product.id}"
    assert :redirect
    cart = assigns(:shopping_cart)
    item = cart.shopping_cart_items.take
    assert_equal item.quantity, 2
    post "/it/shopping_cart/down/#{@product.id}"
    item = cart.shopping_cart_items.take
    assert_equal item.quantity, 1
  end

  if !ENV['IS_TRAVIS'] # ignore with travis because travis dont like ssl to paypal
    test "user can place a order of a cart" do
      @product = products(:product_one)
      put_item_in_cart @product
      get '/express_checkout'
      assert :redirect
    end
  end

  def put_item_in_cart product
    post shopping_cart_path(product_id: product.id, locale: 'it')
  end
end
