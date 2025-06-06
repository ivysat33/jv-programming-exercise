describe GithubApiService do
  let(:username) { 'user' }
  let(:service) { described_class.new }

  describe '#user_events' do
    let(:body) do
      {
        events: [
          { type: 'PushEvent', repo: { name: 'repo1' } },
          { type: 'PullRequestEvent', repo: { name: 'repo2' } },
          { type: 'PullRequestEvent', repo: { name: 'repo2' } },
          { type: 'PullRequestEvent', repo: { name: 'repo1' } },
          { type: 'PushEvent', repo: { name: 'repo3' } },
          { type: 'CommitEvent', repo: { name: 'repo3' } },
          { type: 'CommitEvent', repo: { name: 'repo1' } },
          { type: 'CommitEvent', repo: { name: 'repo1' } },
          { type: 'CommitEvent', repo: { name: 'repo2' } },
          { type: 'OtherEvent', repo: { name: 'repo2' } },
        ]
      }.to_json
    end

    let(:expected_result) do
      [
        'PullRequestEvent',
        'CommitEvent',
        'PushEvent'
      ]
    end

    # Handle non 200 status codes
    it 'fetches user info from GitHub' do
      stub_request(:get, "https://api.github.com/users/#{username}/events")
        .to_return(status: 200, body: body, headers: { 'Content-Type' => 'application/json' })


      result = service.user_events(username)
      expect(result).to eq(expected_result)
    end
  end

  describe '#list_repos' do
  # TODO: Handle non 200 status codes
    it 'fetches user repositories from GitHub' do
      stub_request(:get, "https://api.github.com/users/#{username}/repos")
        .to_return(status: 200, body: [{ name: 'repo1' }].to_json, headers: { 'Content-Type' => 'application/json' })

      result = service.list_repos(username)
      expect(result.first['name']).to eq('repo1')
    end
  end
end