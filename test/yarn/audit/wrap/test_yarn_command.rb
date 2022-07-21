# frozen_string_literal: true

require "test_helper"

class Yarn::Audit::YarnCommand < Minitest::Test
  def setup
    @output_str = StringIO.new
  end

  def test_help_option
    assert_raises(Yarn::Audit::Wrap::ExitEarlyError) {
      Yarn::Audit::Wrap::OptParser.new(["--help"], output: @output_str)
    }
    refute_nil(@output_str)
    assert_match(/Usage:/, @output_str.string)
  end
end
