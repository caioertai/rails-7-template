gem "haml-rails"
gem "dartsass-rails"

gem_group :development do
  gem "erb2haml"
  gem "standardrb"
end

after_bundle do
  # Create and Migrate DB
  rails_command  "db:create db:migrate"

  # Replace ERB templates with HAML
  rails_command  "haml:replace_erbs"

  # Add home page
  generate(:controller, :pages, :home, "--skip-routes", "--no-test-framework", "--skip-helper")
  route 'root "pages#home"'

  # DART SASS Config
  rails_command  "dartsass:install"
  run "rm app/assets/stylesheets/application.css"
  run "mv app/assets/stylesheets/application.scss app/assets/stylesheets/application.sass"
  initializer "dart_sass.rb", <<~RUBY
    Rails.application.config.dartsass.builds = {
      "application.sass"  => "application.css",
    }
  RUBY
end
