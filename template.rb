gem "haml-rails"

gem_group :development do
  gem "cssbundling-rails"
  gem "erb2haml"
  gem "standardrb"
end

after_bundle do
  rails_command  "haml:replace_erbs"
  rails_command  "css:install:sass"

  generate(:controller, :pages, :home, "--skip-routes", "--no-test-framework", "--skip-helper")
  route 'root "pages#home"'

  # The following is the answer to:
  # Add "scripts": { "build:css": "sass ./app/assets/stylesheets/application.sass.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules" } to your package.json
  inject_into_file "package.json", after: "  }" do
    <<~TXT
      ,
        "scripts": {
          "build:css": "sass ./app/assets/stylesheets/application.sass.scss:./app/assets/builds/application.css --no-source-map --load-path=node_modules"
        }
    TXT
  end
end
