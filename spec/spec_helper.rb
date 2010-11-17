# encoding: utf-8

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'pennies'
require 'spec'
require 'spec/autorun'

RSpec::Runner.configure do |config|

end
