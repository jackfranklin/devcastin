require 'mongoid'
require 'mongoid_paranoia'
require 'mongoid-history'

module Devcasts
  module Models
    class BaseModel
      include Mongoid::Document
      include Mongoid::Paranoia
      include Mongoid::Timestamps
    end
  end
end
