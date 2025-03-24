# frozen_string_literal: true

require_relative "dropbox_business/version"
require_relative "strategies/dropbox_business"

module Omniauth
  module DropboxBusiness
    class Error < StandardError; end
  end
end
