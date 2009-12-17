#
# Author:: Michele Mendel
# Date:: Oslo 2008-07-16
#

require 'pp'
require 'mididrum'

seq = DrumSequence.new('fib1.mid',300)

nl = seq.note_length('quarter')
nof = 400

drums = [45,47,48,50] #toms
drums = [42,35,38,54,45,47,48,50]
note_lengths = [5,8,13,21]
note_lengths = [2,3,5,8,13,21,34,55]

rc = [42,51]
pp rc[rand(1)]

drums.each_index do |idx|
  vel_min,vel_max = 80, 127
  dt = DrumTrack.new(seq)
  
  (nof/note_lengths[idx]).times do |di|
    velocity = rand(vel_max+1-vel_min)+vel_min
    
    if idx==0
      drums[idx] = [42,51][rand(2)] if idx==0
      velocity -= 40
    end
  
    dt.add(drums[idx], velocity, nl*note_lengths[idx])
  end  
end

seq.save

