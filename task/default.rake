task :default do
  Rake::Task['test:spec'].invoke
end
