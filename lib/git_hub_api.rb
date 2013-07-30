require 'httparty'

class GitHubApi
  include HTTParty
  base_uri 'https://api.github.com'

  def repos(user)
    a = self.class.get("/users/#{user}/repos")
    a.body
  end

  def langs(user, repo)
    self.class.get("/repos/#{user}/#{repo}/languages")
  end
end
