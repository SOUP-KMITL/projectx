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

    return unless res.ok?

    JSON.parse(res.body)
  end

  def reports(session_id)
    res = self.class.get("/sessions/#{session_id}/reports")

    return unless res.ok?

    JSON.parse(res.body)
  end

  def report(session_id, report_name)
    res = self.class.get("/sessions/#{session_id}/reports/#{report_name}")

    return unless res.ok?

    JSON.parse(res.body)
  end
end
