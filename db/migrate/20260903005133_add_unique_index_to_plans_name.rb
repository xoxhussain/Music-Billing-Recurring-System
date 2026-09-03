class AddUniqueIndexToPlansName < ActiveRecord::Migration[8.1]
  def change
    add_index :plans, :name, unique: true
    add_check_constraint :plans,
                         "monthly_fee >= 0",
                         name: "plans_monthly_fee_non_negative"
  end
end
