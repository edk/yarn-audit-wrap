# frozen_string_literal: true

require "test_helper"

class Yarn::Audit::Config < Minitest::Test
  def setup
    super
    @opts = Yarn::Audit::Wrap::OptParser.new(["--ignorelist=test/testdata/yarn-audit.yml"])
    @config = Yarn::Audit::Wrap::Config.new(opts: @opts)
  end

  def test_config
    assert(@config.ignores.size == 1)
  end

  def test_missing_config
    assert_raises(Yarn::Audit::Wrap::FileNotFoundError) do
      with_captured_stderr {
        @opts = Yarn::Audit::Wrap::OptParser.new(["--ignorelist=missing-file.yml"])
      }
    end
  end
end
