# encoding: utf-8
RSpec.configure do |config|
  config.color = true
  config.tty = true
  config.formatter = :documentation
end
puts File.expand_path(File.join('..', 'lib'), File.dirname(__FILE__))
$LOAD_PATH << File.expand_path(File.join('..', 'lib'), File.dirname(__FILE__))
__END__
