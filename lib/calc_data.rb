require './lib/git_hub_api'
require 'json'

class CalcData
  attr_reader :langs

  def initialize(name)
    @gh = GitHubApi.new
    @name = name
  end

  def favourite_language
    repos = get_repos_for_user
    return "User not found" if repos.nil?
    summed_languages = sum_languages(repos)
    highest = highest_from(summed_languages)
    "User #{@name} loves #{highest.first} the most"
  end

  private

  def get_repos_for_user
    get_repos = @gh.repos(@name)
    parsed = JSON.parse(get_repos)
    parsed.empty? ? nil : parsed
  end

  def sum_languages(repos)
    langs = {}
    langs.default = 0
    repos.each do |repo|
      next if repo['language'].nil?
      langs[repo['language'].to_sym] += 1
    end
    langs
  end

  def highest_from(summed_languages)
    sorted = summed_languages.sort_by { |lang, count| count }
    sorted.last
  end
end
