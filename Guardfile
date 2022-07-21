# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard :standardrb, fix: false, all_on_start: true do
  UI.info "StandardRb is initialized"
  watch(/.+\.rb$/)
end

guard :minitest, all_after_pass: true do
  # with Minitest::Unit
  watch(%r{^bin/}) { "test" }
  watch(%r{^test/(.*)/?test_(.*)\.rb$}) { "test" }
  watch(%r{^lib/(.*/)?([^/]+)\.rb$}) { "test" }
  watch(%r{^test/test_helper\.rb$}) { "test" }
end
