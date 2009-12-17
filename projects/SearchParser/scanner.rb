
# 
# === Scanner for a search parser
#
# Author:: Michele Mendel
# Date:: Oslo 2005-10-11
# Version:: 1.0
#
# ==== EBNF GRAMMAR for the LEXICON
#   token = letter(letter)* | '&' | '|' | '!' | '(' | ')'
#   separator = space | EOL
#   letter = a-z | A-Z | 0-9
#
# ==== Keywords and Misc
#   EOT - \u000  (we don't need this)
#   EOL - \n
#   keywords: and, or, not, &, |, !
#   ("and", "or" and "not" are case insensitive)
#


class Token
    attr_reader :kind, :spelling, :position
    
    #
    def initialize(kind, spelling, position)
        @kind = kind
        @spelling = spelling
        @position = position-spelling.size-1
        check_keyword
    end
    
    #
    def check_keyword
        spelling = @spelling.downcase
        case spelling
        when "and", "&"
            @kind = :AND
        when "or", "|"
            @kind = :OR
        when "not", "!"
            @kind = :NOT
        end
    end
end

#
class Scanner
    attr_reader :errors, :source

    def initialize(source, verbose=false)
        @verbose = verbose
        @source = source
        @position = 0
        @separators = []
        @errors = []
        
        @literals_az = 'a'..'z'
        @literals_AZ = 'A'..'Z'
        @literals_09 = '0'..'9'
        @separators = [' ' '\n']
        
        take_it(false) #Prime @cur_char
    end
    
    # ----- PUBLIC METHODS -----
    public
    
    # Returns a token from the source
    def scan
        @spelling = ""
        scan_token
        Token.new(@kind, @spelling, @position)
    end
    
    # Method that takes a block
    def scan_all
        while(@cur_char != "")
            yield(scan)
        end
    end
    
    # Returns an array of legal tokens
    def get_tokens
        ret = []
        scan_all{|t| ret << t}
        ret
    end
    
    #
    def errors
        @errors.each{|e| yield e}
    end
    
    #
    def report_errors
        if(!@errors.empty?)
            puts "\nLexical Errors:"
            errors{|e|
                puts e
            }
        end
    end


    # ----- PRIVATE METHODS -----
    private
    #
    def scan_token
        case @cur_char
        when @literals_az, @literals_AZ, @literals_09
            take_it
            while(@literals_az === @cur_char || 
                  @literals_AZ === @cur_char ||
                  @literals_09 === @cur_char)
                take_it
            end
            @kind = :SEARCHSTRING
        when "&", "|", "!"
            take_it
            @kind = :OPCHAR
        when ")"
            take_it
            @kind = :RPAREN
        when "("
            take_it
            @kind = :LPAREN
        when " ", "\n"
            skip_it
            scan_token
        when ""
            @kind = :EOT
        else
            @errors << "Illegal character (#{@cur_char}) at pos #{@position-1}"
            skip_it
            scan_token
        end
    end
        
    #
    def take_it(add_to_spelling=true)
        @spelling << @cur_char if add_to_spelling
        @cur_char = @source[@position,1]
        puts "#{@position} : #{@cur_char} - #{caller[0]}" if @verbose
        @position += 1            
    end
    
    def skip_it
        take_it(false)
    end        
end



# Usage

if(__FILE__ == $0)

    
    # 1.
    #~ str = "string!(ruby|c) # go4it"
    #~ puts str, ''
    
    #~ scanner = Scanner.new(str)
    #~ scanner.scan_all{|token|
        #~ puts "#{token.kind},#{token.spelling},#{token.position}"
    #~ }
    
    #~ scanner.report_errors
        
    # 2. 
    #~ str = "string!(ruby|c) # go4it"
    #~ puts str, ''
    
    #~ scanner = Scanner.new(str)
    #~ tokens = scanner.get_tokens
    #~ tokens.each{|t| 
        #~ puts "#{t.kind},#{t.spelling},#{t.position}"
    #~ }
    #~ scanner.report_errors
    
    # 3. Probably a typical use in a parser
    str = "good & bye ¤   ¤ "
    puts str, ''
    
    scanner = Scanner.new(str)
    t = scanner.scan
    while(t.kind != :EOT)
        t = scanner.scan
        puts "#{t.kind},#{t.spelling},#{t.position}"
    end
    
    scanner.report_errors

end