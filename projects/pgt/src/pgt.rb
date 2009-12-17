#
# Pierre Gildesgame Tournament
#
# Author:: Michele Mendel
# Date:: Oslo 2009-04-24
#
# see:: http://en.wikipedia.org/wiki/Round-robin_tournament
# see:: http://www.teamopolis.com/tools/round-robin-generator.aspx
#

require 'pp'
require 'data'
require 'schedule'
require 'csv_report'

def schedules_multiple_field_setups
#  [:field_setup1,:field_setup2,:field_setup3].each do |field_setup|
  [:field_setup2].each do |field_setup|
    div_setup = :div_setup1

    pgt = Schedule.new(field_setup, div_setup)
    csv = CSV_report.new(pgt)

    schedule = pgt.generate_schedule

    csv.schedule(schedule, field_setup)
    csv.div_matches(pgt)
    csv.div_teams
  end
end

def schedules_multiple_div_setups
  [:div_setup1,:div_setup2,:div_setup3].each do |div_setup|
    field_setup = :field_setup1

    pgt = Schedule.new(field_setup, div_setup)
    csv = CSV_report.new(pgt)

    schedule = pgt.generate_schedule

    csv.schedule(schedule, div_setup)
    csv.div_matches(pgt)
    csv.div_teams
  end
end

def match_list(field_setup, div_setup)
  schedule = Schedule.new(field_setup, div_setup)
  ml = schedule.make_match_list
  ml.each do |m|
    puts "#{m[:div]}:#{m[:teams][0]}-#{m[:teams][1]}"
  end
  pp ml.size
end

#schedules_multiple_field_setups
#schedules_multiple_div_setups
#match_list(:field_setup1, :div_setup2)


schedule = Schedule.new(:field_setup1, :div_setup1)
csv = CSV_report.new(schedule)
#csv.div_matches(schedule)

#csv.score_card(schedule.generate_schedule)
#pp pgt.make_empty_schedule

