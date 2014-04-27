task :console do
  require 'irb'
  require 'irb/completion'
  require 'rack/simple_auth'
  ARGV.clear
  IRB.start
end
