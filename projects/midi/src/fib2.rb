#
# Author:: Michele Mendel
# Date:: Oslo 2008-07-16
#

require 'pp'
require 'mididrum'

def bin_drum(bin_seq,bpm)
  seq = DrumSequence.new('fib2.mid',bpm)

  nl = seq.note_length('quarter')
  #45 47 48 50
  drum1 = 45
  drum2 = 50

  dt = DrumTrack.new(seq)
  bin_seq.split('').each do |b|
    drum = (b=='0') ? drum1 : drum2
    dt.add(drum, 127, nl)
  end  

  seq.save
end

# Fibonacci Substitution Sequence
# see::Fibonacci Substitution Sequence
def generate_fib_sub_seq(nof_steps)
  ss = "0"
  rs = ""
  nof_steps.times do
    rs = ""
    ss.split('').each do |v|
      rs << (v=="0" ? "01" : "001")
    end
    ss = rs
  end
  rs
end

rs = generate_fib_sub_seq(7)
bin_drum(rs,400)


