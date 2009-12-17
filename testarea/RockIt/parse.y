class Calcparser
rule
  target: exp { print val[0] }

  exp: exp '+' exp
     | exp '*' exp
     | '(' exp ')'
     | NUMBER
end

