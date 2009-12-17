#
# Ranking
#
# Author:: Michele Mendel
# Date:: Oslo 2009-05-11
#
# Ranking:
# 1. Number of points in all matches
# 2. Number of points in the internal matches between teams with a equal number of points
# 3. Best goal difference in all matches
# 4. Most goals scored in all matches
#

require 'pp'
require 'util'
require 'csv'

#
def get_scores(score_card_file)
  score_card = []

  CSV.open(score_card_file, 'r') do |row|
    row.shift
    score_card << row
  end

  divs = {}
  score_card.flatten.each do |row|
    div_id, teams, score = row.split(':')
    divs[div_id] ||= []
    divs[div_id] << [teams, score]
  end
  divs
end

#points, wins, loses, ties, goals for, goals against
def calculate_stats(scores)
  teams = {}

  scores.each do |score|
    t = score[0].split('-')
    s = score[1].split('-').map {|sc| sc.to_i}

    2.times do |i|
      teams[t[i]] ||= {:gf=>0, :ga=>0, :wn=>0, :lo=>0, :ti=>0, :pt=>0 }
      teams[t[i]][:gf] += s[i]
      teams[t[i]][:ga] -= s[(i-1)%2]
    end

    if(s[0]>s[1])
      teams[t[0]][:wn] += 1; teams[t[1]][:lo] += 1
      teams[t[0]][:pt] += 3
    elsif(s[1]>s[0])
      teams[t[1]][:wn] += 1; teams[t[0]][:lo] += 1
      teams[t[1]][:pt] += 3
    else
      teams[t[0]][:pt] += 1; teams[t[1]][:pt] += 1
      teams[t[0]][:ti] += 1; teams[t[1]][:ti] += 1
    end
  end

  teams
end

scores = get_scores("reports/score_card.csv")
#pp scores

stats = {}
scores.each do |div, scores|
  stats[div] = calculate_stats(scores)
end
pp stats