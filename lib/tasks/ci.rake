desc "Run RuboCop and tests"
task ci: [ :test ] do
  sh "bin/rubocop -a"
end
