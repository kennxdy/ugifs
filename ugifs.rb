require 'json'
require 'net/http'
require 'sinatra'


# Get API KEY from config.json file
def get_key
  file = File.read("config.json")

  config = JSON.parse(file)

  key = config["api_key"]

  return key
end

# Checks the minimum amount of search term results
def limit_validator(limit)
  if limit <= 0
    limit = 1
  end

  return limit
end

def get_gifs(search_term, api_key, limit, gifs)
  if search_term
    url = URI.parse("http://api.giphy.com/v1/gifs/search?q=#{search_term}&api_key=#{api_key}&limit=#{limit}")

    response = Net::HTTP.get_response(url)

    buffer = response.body

    result = JSON.parse(buffer)

    if result["data"].empty?
    else
      for i in 0..limit - 1
        gifs.push(result["data"][i]["images"]["original"]["url"])
      end
    end
  end
end

get "/" do
  @api_key = get_key
  @search_term = params[:input]
  @limit = params[:quantity].to_i
  @limit = limit_validator(@limit)
  @gifs = []

  if @api_key.length == 32
    get_gifs(@search_term, @api_key, @limit, @gifs)
  else
    @msg = "Invalid API!"
  end

  erb :index
end
