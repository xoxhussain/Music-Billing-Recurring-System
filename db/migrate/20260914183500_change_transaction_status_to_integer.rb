class ChangeTransactionStatusToInteger < ActiveRecord::Migration[8.1]
  def up
    change_column :transactions, :status, :integer
  end

  def down
    change_column :transactions, :status, :string
  end
end
