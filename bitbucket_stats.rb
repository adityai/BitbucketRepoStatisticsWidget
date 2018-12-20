require 'bitbucket_rest_api'
require 'action_view'
include ActionView::Helpers::DateHelper

class Time
  def acts_like?(duck)
    respond_to? :"acts_like_#{duck}?"
  end
end

config = YAML::load_file('bitbucket.yml')

bitbucket = BitBucket.new :basic_auth => "#{config["login"]}:#{config["password"]}"

SCHEDULER.every '30m', :first_in => 0 do |job|
  config["repos"].each do |name|
    # break up the repo by the / to get the username and the repo name
    repoparts = name.split("/")

    # issues
    begin
      newIssueCount = bitbucket.issues.list_repo(repoparts[0], repoparts[1], {"limit" => 50, "status" => "new"}).size
      openIssueCount = bitbucket.issues.list_repo(repoparts[0], repoparts[1], {"limit" => 50, "status" => "open"}).size
    rescue BitBucket::Error::NotFound
      # the issue tracker has been disabled for this repo
      newIssueCount = "N/"
      openIssueCount = "A"
    end

    # pulls
    pulls = bitbucket.repos.pull_request.list(repoparts[0], repoparts[1])["size"]

    # forks
    forks = bitbucket.repos.forks.list(repoparts[0], repoparts[1])["size"]

    # watchers
    watchers = bitbucket.repos.following.followers(repoparts[0], repoparts[1])["count"]

    # activity
    lastTimestamp = bitbucket.repos.changesets.list(repoparts[0], repoparts[1], {"limit" => 1})["changesets"][0]["timestamp"]
    timestamp = DateTime.parse(lastTimestamp)
    
    send_event(name, {
      repo: repoparts[1],
      issues: newIssueCount + openIssueCount,
      pulls: pulls,
      forks: forks,
      watchers: watchers,
      activity: time_ago_in_words(timestamp).capitalize
    })
  end
end

