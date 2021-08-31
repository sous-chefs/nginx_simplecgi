# nginx_simplecgi CHANGELOG

This file is used to list changes made in each version of the nginx_simplecgi cookbook.

## Unreleased

- Standardise files with files in sous-chefs/repo-management

## 0.3.2 - *2021-06-01*

- resolved cookstyle error: libraries/dispatch-helpers.rb:45:7 convention: `Style/RedundantCondition`

## 0.3.1 (2020-05-05)

- resolved cookstyle error: libraries/dispatch-helpers.rb:52:19 warning: `Lint/SendWithMixinArgument`

## 0.3.0 (2020-02-01)

- Change chef_nginx dependency to nginx
- Require Chef Infra 12.19 or later
- Change the maintainer to Sous Chefs
- Update .gitignore and chefignore
- Add contributing and testing docs
- Remove the Gemfile
- Rename .kitchen.yml to kitchen.yml so it's not hidden

## 0.2.0 (2017-07-18)

- Support for Bluepill has been removed. If you require Bluepill use the 0.1.X release
- This cookbook now requires Chef 12.1 or later
- The nginx dependency has been replaced with chef_nginx which is being actively maintained
- node.set usage has been replaced with a node.override to avoid setting attributes permanently on the node
- Fixed the PHP socket being spawned with an incorrect name in Upstart
- Added the Apache 2.0 license file
- Support for CentOS 5 has been removed as CentOS 5 is EOL
- Package installs now use multi-package installation to speed up Chef runs
- Initial support for Amazon Linux on Chef 13 has been added
- The cheffile has been removed and replaced with Berkshelf
- The suggestion to use the yum-epel cookbook has been changed to a hard requirement as 'suggests' in metadata is deprecated
- A chefignore file has been added to limit the files that are uploaded to the Chef server
- New metadata fields for issues_url, source_url, and chef_version have been added
- This changelog has been added to track changes to the cookbook going forward
- Add symbols in node attributes have been replaced with strings to pass Foodcritic FC001 rule
- Resolved all cookstyle and foodcritic warnings
- Test dependencies have been removed from the Gemfile as testing should be done via ChefDK
- A delivery local mode config file has been added for testing
- Added testing with Travis CI
- Added a basic chefspec to test the converge
