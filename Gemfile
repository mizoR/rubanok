# frozen_string_literal: true

source "https://rubygems.org"

gem "debug", platform: :mri

gemspec

eval_gemfile "gemfiles/rubocop.gemfile"
eval_gemfile "gemfiles/rbs.gemfile"

local_gemfile = ENV.fetch("LOCAL_GEMFILE", "Gemfile.local")

if File.exist?(local_gemfile)
  eval_gemfile local_gemfile
end
