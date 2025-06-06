class GithubApiService
  GITHUB_API_URL = 'https://api.github.com'

  EVENT_COUNT = 3

  def initialize(token = nil)
    @token = token
  end

  # Fetch user info from GitHub
  def user_events(username)
    response = get("/users/#{username}/events")

    response.group_by { |event| event['type'] }
      .sort_by { |_type, events| -events.size }
      .first(EVENT_COUNT).keys
  end

  # List repositories for a user
  def list_repos(username)
    get("/users/#{username}/repos")
  end

  private

  def get(path)
    uri = URI("#{GITHUB_API_URL}#{path}")
    req = Net::HTTP::Get.new(uri)
    req['Accept'] = 'application/vnd.github.v3+json'
    req['User-Agent'] = 'Ruby'
    req['Authorization'] = "token #{@token}" if @token

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end

    raise "GitHub API error: #{res.code}" unless res.is_a?(Net::HTTPSuccess)
    JSON.parse(res.body)
  end
end