require "json"
require "sinatra"
require "time"

set :root, File.dirname(__FILE__)
set :bind, ENV.fetch("BIND", "0.0.0.0")
set :port, Integer(ENV.fetch("PORT", "4567"))
set :server, :puma

APIS = [
  {
    method: "GET",
    path: "/api/ping",
    description: "Simple ping endpoint"
  },
  {
    method: "GET",
    path: "/api/time",
    description: "Returns current UTC time"
  },
  {
    method: "POST",
    path: "/api/echo",
    description: "Echos back JSON or text payload"
  }
].freeze

helpers do
  def json(data, status: 200)
    content_type :json
    halt status, JSON.generate(data)
  end

  def request_body_string
    request.body.rewind
    request.body.read.to_s
  end

  def parse_json_body(raw)
    return nil if raw.strip.empty?
    JSON.parse(raw)
  rescue JSON::ParserError
    nil
  end
end

get "/" do
  content_type :html
  erb :index, locals: { apis: APIS }
end

get "/api/ping" do
  json({ ok: true, message: "pong" })
end

get "/api/time" do
  json({ ok: true, utc: Time.now.utc.iso8601 })
end

post "/api/echo" do
  raw = request_body_string
  parsed = parse_json_body(raw)

  json(
    {
      ok: true,
      content_type: request.media_type,
      raw: raw,
      json: parsed
    }
  )
end

not_found do
  wants_json = request.path_info.start_with?("/api/")
  return erb(:not_found) unless wants_json

  json(
    {
      ok: false,
      error: "not_found",
      message: "No route matches #{request.request_method} #{request.path_info}",
      available_apis: APIS
    },
    status: 404
  )
end

