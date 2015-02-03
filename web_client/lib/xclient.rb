require 'httparty'

class XClient
  include HTTParty

  def initialize(options={})
    self.class.base_uri options[:base_uri]

    @options           = {}
    @options[:api_key] = options[:api_key]
  end

  def signin(username, password)
    res = self.class.post('/signin', body: { username: username,
                                             password: password })

    return unless res.ok?

    JSON.parse(res.body)
  end

  def create_session(options={})
    body = @options.merge(options)
    res  = self.class.post('/sessions', body: body)

    return unless res.ok?

    JSON.parse(res.body)
  end

  def session(session_id)
    res = self.class.get("/sessions/#{session_id}", query: @options)

    return unless res.ok?

    JSON.parse(res.body)
  end

  def tasks
    res = self.class.get('/tasks', query: @options)

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
