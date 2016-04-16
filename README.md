To run rails4_app_template.rb:

1) Have rails 4 installed & switch to that gemset
2) Do either of the following type commands:

rails new blog -m ~/template.rb
rails new blog -m http://example.com/template.rb

Todos:

- Configure shoulda matchers install
- Configure Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
