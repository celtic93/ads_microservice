# frozen_string_literal: true

class Ad < Sequel::Model
  plugin :validation_helpers

  def validate
    super
    validates_presence %i[title description city user_id]
  end
end
