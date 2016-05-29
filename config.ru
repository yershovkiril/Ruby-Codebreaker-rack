require "./lib/racker"
use Rack::Static, :urls => ["/css", "/js"], :root => "public"

run Racker