module Types
  class ProductType < Types::BaseObject
    field :id, Integer, null: false
    field :name, String, null: true
    field :price, Integer, null: false
    field :description, String, null: true

    field :products, [ProductType], null: true
  end
end
