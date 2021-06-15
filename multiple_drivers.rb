require "bundler/setup"
Bundler.require :default

require "action_controller/railtie"
require "minitest/autorun"

class TestApp < Rails::Application
  config.root = __dir__
  config.hosts << "example.org"
  config.session_store :cookie_store, key: "cookie_store_key"
  secrets.secret_key_base = "secret_key_base"

  config.logger = Logger.new($stdout)
  Rails.logger  = config.logger

  routes.draw do
    get "/" => "test#index"
  end
end

class TestController < ActionController::Base
  include Rails.application.routes.url_helpers

  def index
    render plain: "Home"
  end
end

class ChromeGUITest < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome

  def test_stuff
    page.visit "/"
    assert_empty Capybara.current_session.driver.options[:options].args
  end
end

class ChromeHeadlessTest < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :headless_chrome

  def test_stuff
    page.visit "/"
    assert_includes Capybara.current_session.driver.options[:options].args, '--headless'
  end
end
