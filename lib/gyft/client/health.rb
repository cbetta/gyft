class Gyft::Client::Health

  def initialize client
    @client = client
  end

  def check
    @client.get('/health/check')
    true
  rescue SocketError
    false
  end
end
