class CreateModeratedModels < ActiveRecord::Migration[7.1]
  def change
    create_table :moderated_models do |t|
      t.string :text
      t.string :language
      t.boolean :is_text_accepted
      t.boolean :is_language_accepted

      t.timestamps
    end
  end
end
