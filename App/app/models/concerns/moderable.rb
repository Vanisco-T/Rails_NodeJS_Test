# app/models/concerns/moderable.rb
require 'net/http'

module Moderable
  extend ActiveSupport::Concern

  included do
    before_save :moderate_content
  end

  def moderate_content
    columns_to_moderate.each do |column|
      content = send(column)
      language = 'fr-FR' # Langue par défaut

      # Appel à l'API de modération qui va nous retourner la probabilte
      rejection_probability = moderation_api_predict(content, language)
      #puts "#{rejection_probability}"
      # Stockage du résultat dans la colonne is_accepted
      #l'api nous retourne la probabilite que le contenu doit etre réjecter

      #update_columns("is_#{column}_accepted" => rejection_probability < 0.5)
      assign_attributes("is_#{column}_accepted" => rejection_probability < 0.5)
    end
  end

  private
  #fonction pour appeler api de moderation
  def moderation_api_predict(text, language)
    api_url = 'https://moderation.logora.fr/predict'
    uri = URI("#{api_url}?text=#{URI.encode_www_form_component(text)}&language=#{URI.encode_www_form_component(language)}")
    #puts "#{uri}"
    response = Net::HTTP.get(uri)
    result = JSON.parse(response)
    prediction = result['prediction']["0"]
    #puts "#{prediction}"
    prediction #retourner la prediction de api
  end

  def columns_to_moderate
    #la specification de la collone a moderer
    [:text]
  end
end
