#
# Making csv reports
#
# Author:: Michele Mendel
# Date:: Oslo 2009-04-24
#

require 'data'
require 'csv'
require 'schedule'

class CSV_report

  def initialize(schedule)
    @field_setup = schedule.field_setup
    @div_setup = schedule.div_setup
  end


  #
  def schedule(schedule, filename_addon)
    CSV::Writer.generate(get_file("schedule_#{filename_addon}.csv"), ',') do |csv|
      csv << ["Day","Slot", FIELDS[@field_setup].max[1]].flatten
      csv << []

      schedule.each do |day|
        day_idx = day[:day][-1].chr

        day[:slots].each do |slots|
          row = [day_idx, get_time(slots[:time])]
          slots[:matches].each do |match|
            if(!match[:teams].nil?)
              div = match[:teams][:div]
              teams = match[:teams][:teams][0] + "-" + match[:teams][:teams][1]
              teams += ":" + match[:referees]
              row << [div + ":" + teams]
            end
          end
          csv << row
        end
        csv << []
      end

    end
  end

  #
  def score_card(generated_schedule)
    CSV::Writer.generate(get_file("score_card.csv"), ',') do |csv|

      generated_schedule.each do |day|
        csv << [day[:day].to_s]
        day[:slots].each do |slots|
          add_row = false
          row = []
          row << get_time(slots[:time])

          slots[:matches].each do |match|
            if(!match[:teams].nil?)
              add_row = true
              div = match[:teams][:div]
              teams = match[:teams][:teams][0] + "-" + match[:teams][:teams][1]
              row << div + ":" + teams + ":0-0"
            end
          end
          csv << row if add_row
        end
      end

    end
  end

  #
  def div_matches(pgt)
    CSV::Writer.generate(get_file("divisions_matches.csv"), ',') do |csv|
      DIVISIONS[@div_setup].each do |div, teams|
        pairs = []
        pgt.make_roundrobin(teams.clone).each do |pair|
          pairs << "#{pair[0]}-#{pair[1]}"
        end
        csv << [div, pairs].flatten
      end
    end
  end


  def div_teams
    csv = ""
    div_teams = DIVISIONS[@div_setup].sort.map { |d| d[1] }
    csv += DIVISIONS[@div_setup].keys.sort.join(',') + "\n"

    (0..DIVISIONS[@div_setup].size).each do |div_idx|
      div_teams.each do |teams|
        csv += teams[div_idx] unless teams[div_idx].nil?
        csv += ","
      end
      csv += "\n"
    end

    save_file(csv, "divisions_teams.csv")
    csv
  end

end






##########################################
## old stuff


#
def schedule_v1(schedule)
  csv = ""
  csv += "Fields," + FIELDS[@field_setup].max[1].join(',') + "\n"

  schedule.each do |day|
    csv += day[:day].to_s + "\n"
    day[:slots].each do |slots|
      #      csv += slots[:time].to_s + ","
      csv += get_time(slots[:time]) + ","
      slots[:matches].each do |match|
        if(match[:teams].nil?)
          csv += ","
        else
          div = match[:teams][:div]
          teams = match[:teams][:teams][0] + "-" + match[:teams][:teams][1]
          teams += ":" + match[:referees]
          csv += div + ":" + teams + ","
        end
      end
      csv += "\n"
    end
  end

  save_file(csv, "schedule.csv")
  csv
end
