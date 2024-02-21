
# Require necessary gems
require 'active_support/concern'
require 'json'
require 'net/http'
require 'active_record'
require 'test_helper'

# Le concern de modération
module Moderable
  extend ActiveSupport::Concern

  included do
    before_save :moderate_content
  end

  def moderate_content
    columns_to_moderate.each do |column|
      content = send(column)
      language = 'fr-FR' # Langue par défaut

      # Appel à l'API de modération
      rejection_probability = moderation_api_predict(content, language)

      # Stockage du résultat dans la colonne is_accepted
      update_column("is_#{column}_accepted", rejection_probability < 0.5)
    end
  end

  private

  def moderation_api_predict(text, language)
    api_url = 'https://moderation.logora.fr/predict'
    uri = URI(api_url)
    params = { text: text, language: language }

    response = Net::HTTP.post_form(uri, params)
    result = JSON.parse(response.body)

    result['probability']
  end

  def columns_to_moderate
    # Spécifiez ici les colonnes que vous souhaitez modérer
    [:text, :language]
  end
end

# Une classe qui souhaite faire appel à la modération de ses attributs
class ModeratedModel < ActiveRecord::Base
  include Moderable
 attribute :text, :string
 attribute :language, :string
end

class ModeratedModelTest < ActiveSupport::TestCase
    test 'content is moderated on save' do
      # Créez une instance de votre modèle modéré
      moderated_model = ModeratedModel.new(your_column_1: 'content', your_column_2: 'content')
  
      # Enregistrez le modèle (ce qui devrait déclencher la modération)
      moderated_model.save
  
      # Assurez-vous que les colonnes modérées ont été acceptées
      assert_equal true, moderated_model.is_your_column_1_accepted
      assert_equal true, moderated_model.is_your_column_2_accepted
    end
end

