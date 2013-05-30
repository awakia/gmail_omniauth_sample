class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :from
      t.string :to
      t.string :subject
      t.string :date
      t.string :message_id
      t.string :in_reply_to
      t.string :content_type
      t.string :charset
      t.text :references
      t.text :header
      t.text :body

      t.timestamps
    end
    add_index :emails, :from
    add_index :emails, :message_id
  end
end
