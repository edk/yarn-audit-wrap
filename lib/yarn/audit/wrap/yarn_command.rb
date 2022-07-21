module Yarn
  module Audit
    module Wrap
      class YarnCommand
        def initialize opts:
          @opts = opts
        end

        def run
          Dir.chdir(APP_ROOT) do
            yarn = ENV["PATH"].split(File::PATH_SEPARATOR)
              .select { |dir| File.expand_path(dir) != __dir__ }
              .product(["yarn", "yarnpkg", "yarn.cmd", "yarn.ps1"])
              .map { |dir, file| File.expand_path(file, dir) }
              .find { |file| File.executable?(file) }

            if !yarn
              warn "Yarn executable was not detected in the system."
              warn "Download Yarn at https://yarnpkg.com/en/docs/install"
              exit 1
            end
          end
          outfile = Shellwords.escape(opts[:audit_json].to_s)
          system("yarn audit --json > #{outfile}")
        end
      end
    end # Wrap
  end
end
