require 'json'
require 'net/http'
require 'sinatra'


def get_key
  file = File.read('config.json')

  config = JSON.parse(file)

  key = config["api_key"]

  return key
end

def limit_validator(limit)
  if limit <= 0
    limit = 1
  end

  return limit
end


get '/' do
  @api_key = get_key
  @search_term = params[:input]
  @limit = params[:quantity].to_i
  @limit = limit_validator(@limit)
  @content = []

  if @search_term
    url = URI.parse("http://api.giphy.com/v1/gifs/search?q=#{@search_term}&api_key=#{@api_key}&limit=#{@limit}")

    response = Net::HTTP.get_response(url)

    buffer = response.body

    result = JSON.parse(buffer)

    for i in 0..@limit - 1
      @content.push(result["data"][i]["images"]["original"]["url"])
    end
  end

  erb :index
end
