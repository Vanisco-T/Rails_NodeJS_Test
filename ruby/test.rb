require 'active_support/concern'
require 'json'
require 'net/http'
require 'active_record'
require 'rails_helper'

RSpec.describe Moderable, type: :concern do
  class ModeratedModelTest < ActiveRecord::Base
    include Moderable
    attribute :text, :string
    attribute :language, :string
  end

  it 'moderates content and updates is_accepted column' do
    moderated_model = ModeratedModelTest.new(text: 'Contenu à modérer', language: 'fr-FR')

    allow(moderated_model).to receive(:moderation_api_predict).and_return(0.3)

    moderated_model.save

    expect(moderated_model.is_text_accepted).to eq(true)
  end
end
