# Description

This is a [Dashing](http://shopify.github.com/dashing) widget that is based on the [Dashing GitHub Stats](https://github.com/cmaujean/dashing-github-stats) widget. This widget displays Last Activity, Open Issues, Open Pulls, Forks, and Watchers of a given set of BitBucket repositories.

# Setup

1. You can either copy and paste these files on your own, or you can use `dashing install 15a542122b198449903d` to copy the files into your dashing directory in place.
2. Edit the bitbucket.yml file to configure the widget. An example configuration is below.
3. Add `bitbucket_rest_api` and `actionview` gems to your Gemfile and run `bundle install`
4. Add the widget to your dashboard erb file. The `data-id` value is the repository you want to display information for. An example is below.

```yaml
repos:
  - atlassian/atlasboard
  - atlassian/atlasboard-atlassian-package

login: my_bitbucket_user
password: my_bitbucket_user
```
__Example 1: bitbucket.yml file example__

```html
<ul>
  <li> data-row="1" data-col="1" data-sizex="1" data-sizey="1">
    <div data-id="atlassian/atlasboard" data-view="BitbucketStats"></div>
    <i class="icon-bitbucket icon-background"></i>
  </li>
</ul>
```
__Example 2: dashboard erb widget placement__
