# frozen_string_literal: true

require "test_helper"

class Yarn::Audit::TestParser < Minitest::Test
  def setup
    super
    @output_str = StringIO.new
  end

  def test_help_option
    assert_raises(Yarn::Audit::Wrap::ExitEarlyError) {
      Yarn::Audit::Wrap::OptParser.new(["--help"], output: @output_str)
    }
    refute_nil(@output_str)
    assert_match(/Usage:/, @output_str.string)
  end

  def test_unknown_option
  end

  def test_file_option
    assert_raises(::Yarn::Audit::Wrap::MissingOptionValueError) do
      Yarn::Audit::Wrap::OptParser.new(["--file"], output: @output_str)
    end

    assert_raises(::Yarn::Audit::Wrap::FileNotFoundError) do
      Yarn::Audit::Wrap::OptParser.new(["--file=expected_missing_json"], output: @output_str)
    end

    rv = Yarn::Audit::Wrap::OptParser.new(["--file=test/testdata/yarn-audit.json"], output: @output_str)
    assert(rv.opts[:audit_json] == "test/testdata/yarn-audit.json")
  end

  def test_config_file_option
    assert_raises(::Yarn::Audit::Wrap::MissingOptionValueError) do
      Yarn::Audit::Wrap::OptParser.new(["--ignorelist"], output: @output_str)
    end

    assert_raises(::Yarn::Audit::Wrap::FileNotFoundError) do
      Yarn::Audit::Wrap::OptParser.new(["--ignorelist=expected_missing_config"], output: @output_str)
    end

    rv = Yarn::Audit::Wrap::OptParser.new(["--ignorelist=test/testdata/yarn-audit.yml"], output: @output_str)
    assert(rv.opts[:audit_config] == "test/testdata/yarn-audit.yml")
  end

  def test_levels_option
    assert_raises(::Yarn::Audit::Wrap::MissingOptionValueError) do
      Yarn::Audit::Wrap::OptParser.new(["--level"], output: @output_str)
    end

    rv = Yarn::Audit::Wrap::OptParser.new(["--level=critical"], output: @output_str)
    assert(rv.opts[:audit_levels] == ["critical"])

    rv = Yarn::Audit::Wrap::OptParser.new(["--level=all"], output: @output_str)
    assert(rv.opts[:audit_levels] == %w[info low moderate high critical])
  end
end
