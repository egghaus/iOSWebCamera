require 'sinatra'

set :public, File.dirname(__FILE__)

post '/upload' do
  haml :response
end

__END__

@@ response
- params.each do |k,v|
  %img{:src => "data:image/png;base64,#{v}"}