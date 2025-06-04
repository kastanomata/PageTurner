ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests.
    fixtures :users, :authors, :books, :clubs, :bookshelves, :bookshelf_contains, :relationships, :memberships, :posts, :likes, :comments, :reports

    # Add more helper methods to be used by all tests here...
    private

    def login_as(user)
      visit login_path
      execute_script("document.getElementById('email_address').value = '#{user.email_address}'")
      execute_script("document.getElementById('password').value = 'password'")
      login_button = find("input[value='Sign in']")
      execute_script("arguments[0].click()", login_button)
      assert_current_path root_path
    end
  end
end
