require 'simplecov'
if ENV["COVERAGE"]
  SimpleCov.start
end
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'text_linear'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

TMP_DICTIONARY_DIR = File.join(File.dirname(__FILE__), '..', '..', 'tmp', 'dictionaries')

RSpec.configure do |config|
  config.before(:all) do
    FileUtils.mkdir_p TMP_DICTIONARY_DIR
  end

  config.after(:all) do
    FileUtils.rm_rf TMP_DICTIONARY_DIR
  end
end

def load_dictionary(name)
  factory_dictionary_filepath = File.join(File.dirname(__FILE__), 'support', 'dictionaries', name)
  tmp_dictionary_filepath = File.join(File.dirname(__FILE__), '..', 'tmp', 'dictionaries', name)
  # copy the fixture dictionary to prevent tests permanently overwriting it
  FileUtils.mkdir_p(File.dirname(tmp_dictionary_filepath))
  FileUtils.cp(factory_dictionary_filepath, tmp_dictionary_filepath)
  TextLinear::Dictionary.load(tmp_dictionary_filepath)
end
