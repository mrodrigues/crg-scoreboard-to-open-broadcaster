require 'rubygems'
require 'crg_scoreboard_extractor'
require_relative 'exporters/team_exporter'
require_relative 'exporters/clock_exporter'

root_uri = ARGV[0]
jam_clock = ClockExporter.new('./data/jam')
period_clock = ClockExporter.new('./data/period')
team1 = TeamExporter.new('./data/team1', root_uri)
team2 = TeamExporter.new('./data/team2', root_uri)

scoreboard_path = root_uri + '/config/autosave/scoreboard-0-now.xml'
puts "Watching #{scoreboard_path}..."
CrgScoreboardExtractor::Watcher.new(scoreboard_path).every(10) do |bout|
  team1.export(bout.team1)
  team2.export(bout.team2)
  jam_clock.set(bout.jam)
  period_clock.set(bout.period)
end
