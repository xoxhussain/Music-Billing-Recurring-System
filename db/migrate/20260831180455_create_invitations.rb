class CreateInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :invitations do |t|
      t.references :inviter, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :email
      t.string :token
      t.datetime :expires_at
      t.datetime :accepted_at

      t.timestamps
    end
  end
end
