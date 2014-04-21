require 'mongoid'

module Devcasts
  module Models
    class BaseModel
      include Mongoid::Document
      include Mongoid::Paranoia
      include Mongoid::Timestamps
    end
  end
end
