desc "Run the specs and generate a code coverage report."

task 'default' => 'spec'

desc 'Run specs'
task 'spec' do
  sh 'rspec'
end

desc 'Run specs and generate coverage report'
task 'coverage' do
  ENV['COVERAGE'] = 'Y'
  Rake::Task['spec'].invoke
end

desc 'Print out lines of code and related statistics.'
task 'stats' do
  puts 'Lines of code and comments (including blank lines):'
  sh "find lib -type f | xargs wc -l"
end

desc 'Print TODO items from the source code'
task 'todo' do
  sh 'grep -ni todo -r lib spec || echo none', verbose: false
end

