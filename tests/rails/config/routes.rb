# frozen_string_literal: true

Rails.application.routes.draw do
  get 'test_cases/xss'
  get 'test_cases/unsafe_render'
  get 'test_cases/render_inline'
  get 'test_cases/unsafe_redirect'
  resources :products
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
