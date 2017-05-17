class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.string :title, null: false, comment: 'question title'
      t.text :body, null: false, comment: 'question body'

      t.timestamps
    end
  end
end
