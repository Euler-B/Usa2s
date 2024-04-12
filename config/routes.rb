Rails.application.routes.draw do
  get '/products/new', to: 'products#new', as: :new_product
  get '/products', to: 'products#index' # index me muestra un conjunto de productos
  # ~> el # me indica que es un metodo, y es alli donde definimos lo que me va
  # devolver el endpoint. (controlador)~>products#index~>(metodo)
  # por convencion la index me devuelve un conjunto de cosas
  # el metodo como nos devuelve algo, necesitamos declarar que es eso que me devuelve ( una vista)
  # M ~> Modelo
  # V ~> Vista
  # C ~> Controlador
  get '/products/:id', to: 'products#show', as: :product
   # show me muestra un unico producto
   # 'as' hace referencia a un helper, y esto es un metodo que resuelve una ruta sin necesidad de declararla completa
  get '/products/:id/edit', to: 'products#edit', as: :edit_product

  post '/products', to: 'products#create'

  delete '/products/:id', to: 'products#destroy'

  patch '/products/:id', to: 'products#update'
end
