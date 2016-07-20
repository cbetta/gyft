class Gyft::Health

  def initialize client
    @client = client
  end

  def check
    @client.get('/health/check')
  end
end
