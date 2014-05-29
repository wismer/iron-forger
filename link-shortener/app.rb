require 'sinatra/base'
require 'redis'


module Linker
  class App < Sinatra::Base; end

  class App
    REDIS = Redis.new

    def redis_links
      REDIS.keys.map do |x| 
        "<li><a href='http://localhost:9393/#{x}'>http://localhost:9393/#{x}</a></li>"
      end.join('')
    end

    def make_short(url)
      list = ('a'..'z').to_a + ('0'..'9').to_a + ('A'..'Z').to_a
      hashed = url.hash
      str = ''
      [39,13,6,34,21,41,30,56].each do |n|
        str += list[hashed % n]
      end
      str
    end

    get '/' do
      erb :index
    end

    post '/url-shorty' do
      if REDIS.get(params[:url]).nil?
        url = make_short(params[:url])
        REDIS.set(url, params[:url])
        "<a href='http://localhost:9393/#{url}'>localhost:9393/#{url}</a>"
      else
        "that's been taken!"
      end
    end

    get '/:shorty' do
      url = REDIS.get params[:shorty]
      redirect to(url)
    end
  end
end