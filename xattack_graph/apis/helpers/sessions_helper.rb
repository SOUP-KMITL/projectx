class SessionNotFoundError < StandardError; end

module SessionsHelper
  def get_session_node(session_id)
    @neo.get_node(session_id)
  rescue Neography::NodeNotFoundException
    raise SessionNotFoundError, "session_id is: #{session_id}"
  end
end
