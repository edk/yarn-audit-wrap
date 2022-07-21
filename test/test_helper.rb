# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "yarn/audit/wrap"

require "minitest/reporters"
Minitest::Reporters.use!

require "minitest/autorun"

require "pry"
require "debug"

def with_captured_stdout
  original_stdout = $stdout # capture previous value of $stdout
  $stdout = StringIO.new # assign a string buffer to $stdout
  yield # perform the body of the user code
  $stdout.string # return the contents of the string buffer
ensure
  $stdout = original_stdout # restore $stdout to its previous value
end
