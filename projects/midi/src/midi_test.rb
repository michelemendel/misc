
# MIDI Instruments
# see::http://midistudio.com/Help/GMSpecs_Patches.htm
#

require 'pp'
require 'midilib/sequence'
require 'midilib/consts'
include MIDI


def new_seq
  seq = Sequence.new()
  # Meta track
  track = Track.new(seq)
  seq.tracks << track
  track.events << Tempo.new(Tempo.bpm_to_mpq(120))
  track.events << MetaEvent.new(META_SEQ_NAME, 'Sequence Name')
  seq
end

def new_track(seq)
  # Notes track
  track = Track.new(seq)
  seq.tracks << track
  # Add a volume controller event (optional).
  track.events << Controller.new(0, CC_VOLUME, 100)
  track
end


# NoteEvent:channel, note, velocity, and delta_time
def all_instruments(seq, track)
  ch = 0
  nl = seq.note_to_delta('quarter')/4
  base = 54
  instr_1 = [12,13,108]
  instr_2 = [91,92]
  instr = 107
  #  (0..126).each do |instr|
  #  (105..112).each do |instr|
  #    [0,2,4,5,7,9,11,12].each do | offset |
  100.times do
    instr = instr_1[rand(instr_1.size)]
    track.events << ProgramChange.new(0, instr, 0)
    offset = [0,2,4,5,7,9,11,12][rand(8)]
    track.events << NoteOnEvent.new(ch, base+offset, 127, nl)
    track.events << NoteOffEvent.new(ch, base+offset, 127, nl)
  end  
  #  end
  track
end


def all_instruments_random(seq, track)
  nl = seq.note_to_delta('8th')/2
  #    (0..126).each do |instr|
  1000.times do
    instr = rand(126)
    offs = [0, 2, 4, 5, 7, 9, 11, 12][rand(8)]
    #    offs = 0
    track.events << ProgramChange.new(0, instr, 0)
    track.events << NoteOnEvent.new(0, 64+offs, 127, 0)
    track.events << NoteOffEvent.new(0, 64+offs, 127, nl)
  end
  track
end

# NoteEvent:channel, note, velocity, and delta_time
def chord(root, seq, track)
  ch = 0
  vel = 120
  instr = 1
  track.events << ProgramChange.new(ch, instr, 0)
  
  [0,4,7].each do | offset |
    track.events << NoteOnEvent.new(ch, root+offset, vel)
    track.events[-1].time_from_start = @time
  end
  
  @time += seq.note_to_delta('quarter')
  
  [0,4,7].each do | offset |
    track.events << NoteOffEvent.new(ch, root+offset, vel)
    track.events[-1].time_from_start = @time
  end
  track.recalc_delta_from_times
end

@time = 0
seq = new_seq
track = new_track(seq)
chord(60, seq, track)
chord(70, seq, track)
#all_instruments(seq, track)
File.open('chord.mid', 'wb') { | file |	seq.write(file) }
