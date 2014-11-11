task :console do
  require 'pry'
  require 'rack/blogengine'
  ARGV.clear
  Pry.start
end
