module Devcasts
  module Routes
    class Index < Base
      # error Models::NotFound do
      #   error 404
      # end
      get '/' do
        @latest_video = Video.last || Struct.new(:title).new('Fake')
        erb :index
      end
    end
  end
end
