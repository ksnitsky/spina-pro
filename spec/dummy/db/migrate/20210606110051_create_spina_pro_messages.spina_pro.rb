# This migration comes from spina_pro (originally 4)
class CreateSpinaProMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :spina_pro_messages do |t|
      t.integer :inbox_id, index: true
      t.datetime :read_at
      t.jsonb :json_attributes, null: false
      t.boolean :spam, default: false, null: false
      t.string :type, null: false
      t.string :email

      t.timestamps
    end
  end
end
