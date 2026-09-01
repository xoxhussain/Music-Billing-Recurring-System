class UpdateSchemaForNewErDiagram < ActiveRecord::Migration[8.1]
  def change
    create_table :roles do |t|
      t.string :role, null: false
      t.timestamps
    end

    add_index :roles, :role, unique: true

    add_reference :users, :role, null: true, foreign_key: true

    reversible do |dir|
      dir.up do
        execute <<~SQL
          INSERT INTO roles (role, created_at, updated_at)
          SELECT 'Admin', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
          WHERE NOT EXISTS (
            SELECT 1 FROM roles WHERE role = 'Admin'
          )
        SQL

        execute <<~SQL
          INSERT INTO roles (role, created_at, updated_at)
          SELECT 'Buyer', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
          WHERE NOT EXISTS (
            SELECT 1 FROM roles WHERE role = 'Buyer'
          )
        SQL

        execute <<~SQL
          UPDATE users
          SET role_id = (
            SELECT id FROM roles WHERE roles.role = 'Admin'
          )
          WHERE role = 'Admin'
        SQL

        execute <<~SQL
          UPDATE users
          SET role_id = (
            SELECT id FROM roles WHERE roles.role = 'Buyer'
          )
          WHERE role = 'User'
        SQL
      end
    end

    remove_column :users, :role, :string

    change_column_null :features, :name, false
    change_column_null :features, :code, false

    add_index :features, :code, unique: true

    add_column :plan_features, :max_unit_price, :decimal

    add_index :plan_features,
              [ :plan_id, :feature_id ],
              unique: true,
              name: "index_plan_features_on_plan_and_feature"

    create_table :subscription_statuses do |t|
      t.references :subscription, null: false, foreign_key: true
      t.string :status, null: false
      t.boolean :is_using, null: false, default: false

      t.timestamps
    end

    remove_reference :usage_entries, :feature, foreign_key: true

    add_reference :usage_entries,
                  :plan_feature,
                  null: false,
                  foreign_key: true


    create_table :new_invitations do |t|
      t.integer :inviter_id, null: false
      t.string :email, null: false
      t.string :token, null: false
      t.datetime :expires_at
      t.datetime :accepted_at

      t.timestamps
    end

    add_foreign_key :new_invitations, :users, column: :inviter_id

    execute <<~SQL
      INSERT INTO new_invitations
        (id, inviter_id, email, token, expires_at, accepted_at, created_at, updated_at)
      SELECT
        id, inviter_id, email, token, expires_at, accepted_at, created_at, updated_at
      FROM invitations
    SQL

    drop_table :invitations

    rename_table :new_invitations, :invitations

    add_index :invitations, :token, unique: true
  end
end
