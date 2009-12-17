require 'pp'

div_setup_1 = {
  'b9394' => %w{kop_1 mal_1 nor_1 kopX1 malX1 norX1},
  'b9596' => %w{kop_1 kop_2 sto_1 sto_2 nor_1},
  'b9798' => %w{kop_1 kop_2 sto_1 got_1 nor_1},
  'b9901' => %w{kop_1 sto_1 hel_1 got_1 nor_1 nor_2},
  'g9394' => %w{kop_1 mal_1 nor_1 kopX1 malX1 norX1},
  'g9596' => %w{kop_1 sto_1 nor_1 kopX1 stoX1 norX1},
  'g9798' => %w{sto_1 got_1 got_2 nor_1}
}
div_setup_test = {
  'b9394' => %w{kop_1 sto_1 got_1 mal_1 nor_1},
  'b9596' => %w{kop_1 kop_2 sto_1 sto_2 nor_1},
  'b9798' => %w{kop_1 sto_1 got_1 nor_1}
}

DIVISIONS = {:div_setup1=>div_setup_1}

field_setup_1 = {
  'Day 1' => ['bane 1','bane 2','bane 3','bane 4','bane 5','bane 6','bane 7','bane 8'],
  'Day 2' => ['bane 1','bane 2','bane 3','bane 4','bane 5','bane 6','bane 7','bane 8'],
  'Day 3' => ['bane 1','bane 2','bane 3','bane 4','bane 5','bane 6','bane 7','bane 8']
}
field_setup_2 = {
  'Day 1' => ['bane 1','bane 2','bane 3','bane 4','bane 5','bane 6','bane 7','bane 8'],
  'Day 2' => ['bane 1','bane 2','bane 3','bane 4','bane 5','bane 6'],
  'Day 3' => ['bane 1','bane 2','bane 3','bane 4','bane 5','bane 6','bane 7','bane 8']
}
field_setup_3 = {
  'Day 1' => ['bane 1','bane 2','bane 3','bane 4','bane 5','bane 6'],
  'Day 2' => ['bane 1','bane 2','bane 3','bane 4','bane 5','bane 6'],
  'Day 3' => ['bane 1','bane 2','bane 3','bane 4','bane 5','bane 6']
}

FIELDS = {:field_setup1=>field_setup_1, :field_setup2=>field_setup_2, :field_setup3=>field_setup_3}


ref01 = 'J_Ebe' # Jonas Eberil  (Got)
ref02 = 'S_Zys' # Simon Zyskind (Got) - helst de minste
ref03 = 'D_Sch' # Dan Schereiber (Got)
ref04 = 'M_Gol' # Max Goldman (Got)
ref05 = 'Rkop1'
ref06 = 'Rkop2'
ref07 = 'Rkop3'
ref08 = 'Rsto1'
ref09 = 'Rsto2'
ref10 = 'Rsto3'
ref11 = 'Rnor1'
ref12 = 'Rnor2'
ref13 = 'Rnor3'
ref14 = 'Rnor4'
ref15 = 'Rnor5'

REFEREES = [ref01,ref02,ref03,ref04,ref05,ref06,ref07,ref08,ref09,ref10,ref11,ref12,ref13,ref14,ref15]

SLOTS = {
  'Day 1' => [:s6,:s7,:s8],
  'Day 2' => [:s2,:s3,:s4,:s6,:s7,:s8, :s9],
  'Day 3' => [:s2,:s3,:s4,:s5]
}

def get_time(s)
  case s.to_s
  when 's1' then '08.00-09.00'
  when 's2' then '09.00-10.00'
  when 's3' then '10.00-11.00'
  when 's4' then '11.00-12.00'
  when 's5' then '12.00-13.00'
  when 's6' then '13.00-14.00'
  when 's7' then '14.00-15.00'
  when 's8' then '15.00-16.00'
  when 's9' then '16.00-17.00'
  end
end



