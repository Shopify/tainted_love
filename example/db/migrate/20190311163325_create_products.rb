# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string(:name)
      t.text(:description)
      t.integer(:price)

      t.timestamps
    end
  end
end
