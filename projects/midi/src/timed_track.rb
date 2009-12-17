# 
# From Ruby Cookbook
# 
 
require 'pp'
require 'midilib'
require 'midilib/io/seqreader'
require 'midilib/io/seqwriter'
require 'midilib/consts'

include MIDI

#
class TimedTrack < MIDI::Track
  MIDDLE_C = 60

  #
  def initialize(channel, song)
    super(song)
    @channel = channel
    @time = 0
  end
  
  # Tell this track's channel to use the given instrument, and
  # also set the track's instrument display name.
  def instrument=(instrument)
    @events << MIDI::ProgramChange.new(@channel, instrument)
    super(GM_PATCH_NAMES[instrument])
  end
  
  # Add one or more notes to sound simultaneously. Increments the per-track
  # timer so that subsequent notes will sound after this one finishes.
  def notes(offsets, velocity=127, duration='quarter')
    offsets = [offsets] unless offsets.respond_to? :each
    offsets.each do |offset|
      event(NoteOnEvent.new(@channel, offset, velocity))
    end
    @time += @sequence.note_to_delta(duration)
    offsets.each do |offset|
      event(NoteOffEvent.new(@channel, offset, velocity))
    end
    recalc_delta_from_times
  end

  def event(event)
    @events << event
    event.time_from_start = @time
  end

  # Chords  
  # Major triad in root position
  def major(low_note, velocity=127, duration='quarter')
    notes([0,4,7].collect { |x| x + low_note }, velocity, duration)
  end
end

def text2notes(str)
  @map = YAML.load(File.open("map.yml"))
  str.split('').each do |chr|
    chr.downcase!
    c2t = @map[chr]
    case c2t
    when /drum(\d\d)/
      puts "#{chr}: drum #{$1}"
      @drums.notes($1.to_i, 100, 'quarter')
    when /chord (.+)/
      puts "#{chr}: chord #{$1}"
      @instrument.notes(numbers2array($1,50), 100,'quarter')
    when /note (\d)/
      puts "#{chr}: note #{$1}"
      @instrument.notes(numbers2array($1,70), 100,'quarter')
    else
      #      puts "something else"
      case chr
      when " "
        @instrument.notes(200, 100,'quarter')
        #        @drums.notes(69, 100, 'quarter')  
      end
    end
  end
end

def numbers2array(str,base)
  str.split(' ').collect { |x| x.to_i + base }
end


if(__FILE__==$0)
  MIDDLE_C = 60
  
  song = Sequence.new
  song.tracks << (@instrument = TimedTrack.new(0, song))
  song.tracks << (@drums = TimedTrack.new(9, song))
  
  @instrument.instrument = 0
  @instrument.events << Tempo.new(Tempo.bpm_to_mpq(100))
  
#  str = File.open('fib1.rb').read #"aaeioub"
#  str = File.open('PCSupport.txt').read #"aaeioub"
    str = "natti joel dan avigail"
  text2notes(str)
  
  File.open('text2sounds.mid', 'wb') { |f| song.write(f) }
end