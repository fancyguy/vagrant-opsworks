# -*- mode: ruby; encoding: utf-8 -*-
guard 'spork' do
  watch('Gemfile')
  watch('spec/spec_helper.rb') { :rspec }
end

guard 'yard', stdout: '/dev/null', stderr: '/dev/null' do
  watch(%r{app/.+\.rb})
  watch(%r{lib/.+\.rb})
  watch(%r{ext/.+\.c})
end

guard 'rspec', cmd: 'bundle exec rspec --color --drb --format Fuubar', all_on_start: false, all_after_pass: false do
  watch(%r{^spec/unit/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})          { |m| "spec/unit/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')       { 'spec' }
end
