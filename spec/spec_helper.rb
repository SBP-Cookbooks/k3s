require 'chefspec'
require 'chefspec/policyfile'

RSpec.configuration.policyfile_path = File.join(Dir.pwd, 'policyfiles', 'test.rb')
