require 'spec_helper'
require './lib/git_hub_api'

describe GitHubApi do
  describe "getting user repos" do
    subject { described_class.new.repos(name) }

    context 'returns data for a valid name', vcr: { cassette_name: "get_repos" }  do
      let(:name) { 'ianvaughan' }
      it { should be_true }
    end
  end
end
