require 'rspec/core'

require 'webmock'
include WebMock::API
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.default_cassette_options = {
    record: :once
  }
  c.configure_rspec_metadata!
  # c.allow_http_connections_when_no_cassette = true
end
