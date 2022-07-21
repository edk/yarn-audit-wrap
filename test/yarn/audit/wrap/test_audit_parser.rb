# frozen_string_literal: true

require "test_helper"

class Yarn::Audit::AuditParser < Minitest::Test
  def setup
    super
    @opts = Yarn::Audit::Wrap::OptParser.new(["--file=test/testdata/yarn-audit.json"])
    @audit_file = Yarn::Audit::Wrap::AuditParser.new(opts: @opts)
  end

  def test_audit_file_load
    @audit_file.parse_json_audit
    refute_empty(@audit_file.output)
    assert(@audit_file.output.size == 3)
    assert(@audit_file.select { true }.send(:size) == 2)
  end
end
