module Devcasts
  module Routes
    class Search < Base
      get '/search' do
        search_term = params[:text].downcase
        unless search_term
          redirect "/archives"
          return
        end

        @videos = Video.all.to_a.select do |video|
          video.topics.map(&:downcase).include?(search_term) ||
            video.title.downcase.include?(search_term)
        end

        erb :search_results
      end
    end
  end
end
