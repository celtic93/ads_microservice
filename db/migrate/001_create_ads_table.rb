# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:ads) do
      primary_key :id, unique: true
      String :title, null: false
      String :description, text: true, null: false
      String :city, null: false
      Float :lat
      Float :lon
      foreign_key :user_id, null: false

      DateTime :created_at, null: false, default: Sequel::CURRENT_TIMESTAMP
      DateTime :updated_at, null: false, default: Sequel::CURRENT_TIMESTAMP
    end
  end
end
