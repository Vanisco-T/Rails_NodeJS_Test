require 'test_helper'

class ModeratedModelTest < ActiveSupport::TestCase
  test 'content is moderated on save' do
    # Creation d'une instance de model
    moderated_model = ModeratedModel.new(text: 'bonjour', language: 'fr-FR')
    #sauvegader le modele
    moderated_model.save
    # verifier que ca été accepter
    assert_equal false, moderated_model.is_text_accepted

    #deuxieme model de test
    moderated_model1 = ModeratedModel.new(text:"aujourd’hui on doit parler de l'informatique",language:"fr-Fr")
    moderated_model1.save
    assert_equal true, moderated_model1.is_text_accepted
  end
end
