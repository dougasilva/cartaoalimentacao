class CreateArquivos < ActiveRecord::Migration[5.2]
  def change
    create_table :arquivos do |t|
      t.string :name
      t.string :surname
      t.string :email
      t.string :token
      t.date :admission_date
      t.decimal :available_amount

      t.timestamps
    end
  end
end
