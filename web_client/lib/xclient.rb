require 'httparty'

class XClient
  include HTTParty

  def initialize(options={})
    self.class.base_uri options[:base_uri]

    @api_key = options[:api_key]
  end

  def signin(username, password)
    res = self.class.post('/signin', body: { username: username,
                                             password: password })

    if res.ok?
      JSON.parse(res.body)
    else
      nil
    end
  end
end
