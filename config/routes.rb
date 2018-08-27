Rails.application.routes.draw do
  
  resources :arquivos do
    collection do
      post :import
    end
  end
  root 'arquivos#new'
end
