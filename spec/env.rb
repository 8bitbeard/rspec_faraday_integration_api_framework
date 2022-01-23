Dir[File.join(File.dirname(__FILE__), 'support/commons/*.rb')].sort.each { |file| require_relative file }

require 'faraday'
require 'faraday_middleware'
require 'faker'
require 'pry'
require 'json'
require 'yaml'

URL_CONFIG = YAML.load_file("#{File.dirname(__FILE__)}/support/config/urls.yaml")
API_DATA_FILE = YAML.load_file("#{File.dirname(__FILE__)}/support/data/test_data.yaml")
API_LOGS = ENV['API_LOGS'].eql?('true')
