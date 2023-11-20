class CreateMessagingMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messaging_messages do |t|
      t.text    :body
      t.boolean :read, default: false

      t.references :user, foreign_key: { to_table: :users }
      t.references :institution, foreign_key: { to_table: :institutions }
      t.references :emitter, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
