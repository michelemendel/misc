#
# Drumming with MIDI (midilib)
#   
# Author:: Michele Mendel
# Date:: Oslo 2008-07-16
#
# see::http://midilib.rubyforge.org/
# see::http://www.gilesgoatboy.org/ruby/midi.html
#
 
require 'pp'
require 'midilib'
require 'midilib/io/seqreader'
require 'midilib/io/seqwriter'
require 'midilib/consts'

include MIDI

# Sequence and meta track
class DrumSequence
  attr_accessor :seq
  
  def initialize(song_name, speed=120)
    @song_name = song_name
    @seq = Sequence.new()
    track = Track.new(@seq)
    @seq.tracks << track
    track.events << Tempo.new(Tempo.bpm_to_mpq(speed))
    track.events << MetaEvent.new(META_SEQ_NAME, 'Sequence Name')
  end
  
  def note_length(length='quarter')
    @seq.note_to_delta(length)
  end
  
  def save
    File.open(@song_name, 'wb') { | file | @seq.write(file) }    
  end
end

# Note track
class DrumTrack
  def initialize(seq)
    @track = Track.new(seq)
    seq.seq.tracks << @track
    @track.events << Controller.new(9, CC_VOLUME, 127) #volume controller event (optional)
  end
  
  # NoteOnEvent: channel, note, velocity, and delta_time. 
  def add(instrument=35, velocity=127,note_length=0)
    @track.events << NoteOnEvent.new(9, instrument, velocity, 0)
    @track.events << NoteOffEvent.new(9, instrument, velocity, note_length)
  end
end


