class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.text :body, null: false, comment: 'answer body'

      t.timestamps
    end
  end
end
