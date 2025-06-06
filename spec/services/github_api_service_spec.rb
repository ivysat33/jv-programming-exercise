describe GithubApiService do
  let(:username) { 'user' }
  let(:service) { described_class.new }

  describe '#user_info' do
    it 'fetches user info from GitHub' do
      stub_request(:get, "https://api.github.com/users/#{username}/events")
        .to_return(status: 200, body: { login: username }.to_json, headers: { 'Content-Type' => 'application/json' })


      result = service.user_info(username)
              binding.pry

      expect(result['login']).to eq(username)
    end
  end

  describe '#list_repos' do
    it 'fetches user repositories from GitHub' do
      stub_request(:get, "https://api.github.com/users/#{username}/repos")
        .to_return(status: 200, body: [{ name: 'repo1' }].to_json, headers: { 'Content-Type' => 'application/json' })

      result = service.list_repos(username)
      expect(result.first['name']).to eq('repo1')
    end
  end
end