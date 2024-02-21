class ModeratedModel < ActiveRecord::Base
    include Moderable
    attribute :text, :string
    attribute :language, :string
  end