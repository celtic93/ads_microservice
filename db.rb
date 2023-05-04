# frozen_string_literal: true

database = 'ads_microservice_development'
user     = ENV['PGUSER']
password = ENV['PGPASSWORD']
DB = Sequel.connect(adapter: 'postgres', database: database, host: '127.0.0.1', user: user, password: password)
