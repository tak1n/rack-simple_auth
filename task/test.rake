namespace :test do
  Rake::TestTask.new(:unit) do |t|
    t.libs << "test" << "bin" << "ext" << "controllers" << "helpers" << "models"
    t.test_files = FileList['test/**/*_test.rb']
    t.verbose = true
  end

  # Rake::TestTask.new(:spec) do |t|
    # t.libs << "spec" << "bin" << "ext" << "controllers" << "helpers" << "models"
    # t.test_files = FileList['spec/**/*_spec.rb']
    # t.verbose = true
  # end

  # Cucumber::Rake::Task.new(:feature) do |t|
    # t.cucumber_opts = "features --format pretty"
  # end
  
  task :cleanup do
    system("rm -rf #{File.expand_path('../../', __FILE__)}/test/rack/simple_auth/hmac/logs")
  end
end


