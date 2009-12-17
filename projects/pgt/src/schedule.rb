#
# Working with the schedule
#
# Author:: Michele Mendel
# Date:: Oslo 2009-04-24
#

require 'pp'
require 'data'
require 'util'

class Schedule
  attr_accessor :field_setup, :div_setup

  def initialize(field_setup, div_setup)
    @field_setup = field_setup
    @div_setup = div_setup
  end

  # A schedule has days
  # A day has slots
  # A slot has matches (actually fields)
  def generate_schedule
    match_list = make_match_list
    schedule = make_empty_schedule
    #  pp match_list
    #  pp match_list.size

    scheduled_matches = []
    referee_count = 0
    move_to_next_slot = false

    schedule.each do |day|
      #      puts "#{day[:day]}"
      day[:slots].each do |slots|
        #        puts "  #{slots[:time]}"

        match_count = -1
        move_to_next_slot = false
        match_to_validate = {}

        slots[:matches].each do |match|
          #          puts "  scheduled (#{scheduled_matches.size})"; pp scheduled_matches
          #        puts "match list (#{match_list.size})"; pp match_list
          #          puts "     to_val: "; pp scheduled_matches
          while(!validate_rest_time(match_to_validate, scheduled_matches))
            match_count += 1 #next match on match_list
            #            puts "    CLASH: mc=#{match_count} "
            match_to_validate = {:teams=>match_list[match_count],:day => day[:day], :time => slots[:time]}

            if(match_list.size == match_count)
              #              puts "----> Move to next slot"
              move_to_next_slot=true
              break
            end
          end

          #        puts "move_to_next_slot: #{move_to_next_slot}"
        
          unless(move_to_next_slot)
            scheduled_matches << match_to_validate
            match[:referees] = REFEREES[referee_count%REFEREES.size]
            match[:score] = [0,0]
            match[:teams] = match_list.delete_at(match_count)
            #          print "Adding match: "; pp match
            #          puts "-"*34
            referee_count += 1
            match_count = 0
            match_to_validate = {:teams=>match_list[match_count], :day => match[:day], :time => match[:time]}
          else
            break
          end

        end

      end
    end

    schedule
  end

  # A team can't play the same slot as itself,
  # and needs a rest of minimum one slot.
  def validate_rest_time(match, matches)
    return false if match.empty?
    return true if(matches.empty? || match[:teams].nil?)

    cur_div = match[:teams][:div]
    cur_t1, cur_t2 = match[:teams][:teams][0], match[:teams][:teams][1]
    cur_day_time = match[:day] + match[:time].to_s

    #    puts "val: #{cur_div} #{cur_day_time} #{cur_t1}-#{cur_t2}"; pp match

    matches[0..-1].each do |m|
      div = m[:teams][:div]
      #HACK!!!
      ts = [hacking_extra_matches(m[:teams][:teams][0]),hacking_extra_matches(m[:teams][:teams][1])]
      #      ts = [m[:teams][:teams][0] ,m[:teams][:teams][1]]
      dts = [m[:day] + m[:time].to_s, m[:day] + m[:time].to_s.next]
      #      puts "  #{div} #{dts[0]} #{dts[1]} #{ts[0]}-#{ts[1]}"

      # Validation
      if(div==cur_div &&
            #HACK!!!
          (ts.include?(hacking_extra_matches(cur_t1))||ts.include?(hacking_extra_matches(cur_t2))) &&
            #          (ts.include?(cur_t1)||ts.include?(cur_t2)) &&
          dts.include?(cur_day_time))
        return false
      end
    end
    true
  end

  #
  def make_empty_schedule
    days = []
    SLOTS.each do |day,times|
      slots = []
      times.each do |time|
        matches = []
        FIELDS[@field_setup][day].each do |field|
          matches << {:field=>field, :day=>day, :time=>time}
        end
        slots << {:time=>time, :matches=>matches}
      end
      days << {:day=>day, :slots=>slots}
    end
    days
  end

  #
  def make_match_list
    divisions = []
    div_sizes = []
    DIVISIONS[@div_setup].each do |div, teams|
      pairs = []

      make_roundrobin(teams.clone).each do |pair|
        if(extra_match?(pair[0]) && extra_match?(pair[1]) || !extra_match?(pair[0]) && !extra_match?(pair[1]))
          pairs << {:teams=>pair, :div=>div} #, :uid=>uid(pair, div)}
        end
      end
      divisions << pairs
      div_sizes << pairs.size
    end
    braid_division(divisions, div_sizes.max)
  end

  #
  def make_roundrobin(teams)
    pairs = []
    teams << "-" if teams.size%2 != 0
    ts = teams.size
    nof_rounds = ts-1
    half = ts/2 #games_p_round

    idxs = (0..ts-2).to_a #Positions 1 to last, not 0.

    (0..nof_rounds-1).each do |round|
      t1, t2 = teams[0], teams[idxs[-1]+1]
      pairs << [t1, t2] unless (t1=="-" || t2=="-")
      (0..half-2).each do |idx|
        t1, t2 = teams[idxs[idx]+1],teams[idxs[ts-3-idx]+1]
        pairs << [t1, t2] unless (t1=="-" || t2=="-")
      end

      # rotate
      idxs.collect! { |it| (it-1)%(ts-1) }
    end

    pairs
  end

  #
  def braid_division(divisions, max)
    matches = []
    (0..max).each do |idx|
      divisions.each do |div|
        matches << div[idx] unless div[idx].nil? #Exclude bye matches
      end
    end
    matches
  end

  #
  def make_pairs(teams)
    pairs = []
    (0..teams.size-2).each do |home_team_idx|
      teams[home_team_idx+1..teams.size].each do |away_team|
        pairs << [teams[home_team_idx],away_team]
      end
    end
    pairs
  end

  def referees
    REFEREES.each { |ref| puts ref }
  end

  def extra_match?(match)
    !match.match(/x/i).nil?
  end

  def hacking_extra_matches(match)
    match.downcase.tr('x','_')
  end

end


if($0==__FILE__)
  pgt = Schedule.new(:field_setup1, :div_setup1)

  pp pgt.make_match_list

  exit

  scheduled_matches = [
    {:teams=>{:div=>"b9394", :teams=>["mal_1", "nor_1"]},
      :time=>:s6,
      :day=>"Day 1"},
    {:teams=>{:div=>"b9901", :teams=>["kop_1", "nor_2"]},
      :time=>:s6,
      :day=>"Day 1"},
    {:teams=>{:div=>"g9596", :teams=>["sto_1", "nor_1"]},
      :time=>:s6,
      :day=>"Day 1"},
    {:teams=>{:div=>"b9596", :teams=>["kop_2", "nor_1"]},
      :time=>:s6,
      :day=>"Day 1"},
    {:teams=>{:div=>"g9798", :teams=>["sto_1", "nor_1"]},
      :time=>:s6,
      :day=>"Day 1"},
    {:teams=>{:div=>"b9798", :teams=>["kop_1", "nor_1"]},
      :time=>:s6,
      :day=>"Day 1"},
    {:teams=>{:div=>"g9394", :teams=>["mal_1", "nor_1"]},
      :time=>:s6,
      :day=>"Day 1"},
    {:teams=>{:div=>"b9394", :teams=>["kop_1", "nor_1"]},
      :time=>:s7,
      :day=>"Day 1"}]

  match_list = pgt.make_match_list
  match_count = 0
  pp match_list[0]
  match = match_list[match_count]
  slot = 's7'
  day = "Day 1"
  puts "#{day}#{slot}"

  pp pgt.validate_rest_time(match, day, slot, scheduled_matches)



end






















def generate_schedule_v2
  match_list = make_match_list
  schedule = make_empty_schedule
  #  pp match_list
  #  pp match_list.size

  scheduled_matches = []
  referee_count = 0
  move_to_next_slot = false

  schedule.each do |day|
    puts "#{day[:day]}"
    day[:slots].each do |slots|
      puts "  #{slots[:time]}"

      match_count = -1
      move_to_next_slot = false
      match_to_validate = {}

      slots[:matches].each do |match|
        #          puts "  scheduled (#{scheduled_matches.size})"; pp scheduled_matches
        #        puts "match list (#{match_list.size})"; pp match_list
        #          puts "     to_val: "; pp scheduled_matches
        while(!validate_rest_time_v2(match_to_validate, scheduled_matches))
          match_count += 1 #next match on match_list
          #            puts "    CLASH: mc=#{match_count} "
          match_to_validate = {:teams=>match_list[match_count],:day => day[:day], :time => slots[:time]}

          if(match_list.size == match_count)
            #              puts "----> Move to next slot"
            move_to_next_slot=true
            break
          end
        end

        #        puts "move_to_next_slot: #{move_to_next_slot}"

        unless(move_to_next_slot)
          scheduled_matches << match_to_validate unless match_to_validate[:teams].nil?
          match[:referees] = REFEREES[referee_count%REFEREES.size]
          match[:score] = [0,0]
          match[:teams] = match_list.delete_at(match_count)
          #          print "Adding match: "; pp match
          #          puts "-"*34
          referee_count += 1
          match_count = 0
          match_to_validate = {:teams=>match_list[match_count], :day => match[:day], :time => match[:time]}
        else
          break
        end

      end

    end
  end

  schedule
end

def validate_rest_time_v2(match, day, slot, scheduled_matches)
  cur_div = match[:div]
  cur_t1, cur_t2 = match[:teams][0], match[:teams][1]
  cur_day_time = day + slot

  #    puts "    val: #{cur_div} #{cur_day_time} #{cur_t1}-#{cur_t2}"; #pp match

  scheduled_matches[0..-2].each do |m|
    div = m[:teams][:div]
    ts = [m[:teams][:teams][0] ,m[:teams][:teams][1]]
    dts = [m[:day] + m[:time].to_s, m[:day] + m[:time].to_s.next]
    #      puts "      #{div} #{dts[0]} #{dts[1]} #{ts[0]}-#{ts[1]}"

    # Validation
    if(div==cur_div &&
          (ts.include?(cur_t1)||ts.include?(cur_t2)) &&
          dts.include?(cur_day_time))
      #        puts "--- CLASH"
      #        return false
    end
  end
  true
end
