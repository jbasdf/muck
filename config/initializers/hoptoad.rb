if GlobalConfig.hoptoad_key
  HoptoadNotifier.configure do |config|
    config.api_key = GlobalConfig.hoptoad_key
  end
end