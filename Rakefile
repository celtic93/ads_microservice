#!/usr/bin/env rake
# frozen_string_literal: true

task :app do
  require './ads_microservice'
end
Dir["#{File.dirname(__FILE__)}/lib/tasks/*.rb"].sort.each do |path|
  require path
end
