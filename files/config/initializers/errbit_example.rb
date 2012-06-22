Airbrake.configure do |config|
  config.api_key = 'YOUR ERRBIT APIKEY'
  config.host = 'errbit.msiu.ru'
  config.port= 80
  config.secure = config.port == 443
end
