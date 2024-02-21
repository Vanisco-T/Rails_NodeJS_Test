require 'test_helper'

class ModeratedModelTest < ActiveSupport::TestCase
  test 'content is moderated on save' do
    # Create an instance of your moderated model
    moderated_model = ModeratedModel.new(text: 'bonjour', language: 'fr-FR')

    # Save the model (which should trigger moderation)
    moderated_model.save

    # Ensure that the moderated columns have been accepted
    assert_equal true, moderated_model.is_text_accepted
  end
end
