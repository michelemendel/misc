
# 
# === Search parser
#
# Author:: Michele Mendel
# Date:: Oslo 2005-??-??
# Version:: 1.0
#
# Extract the age and calculate the
# date of birth.
#
# Book:: Programming Language Processors in Java: Compilers and Interpreters
# Amazon:: http://www.amazon.com/exec/obidos/tg/detail/-/0130257869/qid=1129048554/sr=8-1/ref=pd_bbs_1/102-2208931-4360169?v=glance&s=books&n=507846
#
# ==== EBNF GRAMMAR
#   expression = term ('OR' term)*
#   term = factor ('AND'(empty|'NOT') factor)*
#   factor = searchstring | '('expression')'
#

require 'scanner'

class Parser
    attr_reader :errors

    # ----- PUBLIC METHODS -----
    public
    #
    def initialize(scanner, verbose=false)
        @scanner = scanner
        @errors = []
        @verbose = verbose
        @cur_token = @scanner.scan # Prime @cur_token
    end
    
    #
    def parse        
        parse_expression
        
        if(@cur_token.kind != :EOT)
            error("missing EOT")
        end
        
        @scanner.report_errors
        report_errors
    end
    
    #
    def errors
        @errors.each{|e| yield e}
    end

    #
    def report_errors
        if(!@errors.empty?)
            puts "\nSyntax Errors:"
            errors{|e|
                puts e
            }
        end
    end

    # ----- PRIVATE METHODS -----
    private
    
    # --- Parser Methods
    
    # expression = term ('OR' term)*
    def parse_expression
        parse_term
        while(@cur_token.kind == :OR)
            accept_it
            parse_term
        end
    end
    
    # term = factor ('AND'(empty|'NOT') factor)*
    def parse_term
        parse_factor
        while(@cur_token.kind == :AND)
            accept_it
            if(@cur_token.kind == :NOT)
                accept_it
            end
            parse_factor
        end
    end
    
    # factor = searchstring | '('expression')'
    def parse_factor
        case @cur_token.kind
        when :SEARCHSTRING
            accept_it
        when :LPAREN
            accept_it
            parse_expression
            accept(:RPAREN)
        else
            error("")
        end
    end

    # --- Auxiliary Methods
    #
    def accept(expected_kind)
        info("expected_kind=#{expected_kind}")
        if(@cur_token.kind == expected_kind)
            @cur_token = @scanner.scan
        else
            error("expected #{expected_kind}")
        end
    end
    
    #
    def accept_it
        info("")
        @cur_token = @scanner.scan
    end
    
    #
    def error(msg)
        calling_method = caller[0].match("`(.*)'")[1]
        show_error_in_text = @scanner.source + "\n" + '-'*(@cur_token.position-1) + "^"
        @errors << "#{@cur_token.kind}(#{@cur_token.spelling}) at #{@cur_token.position}: caller=#{calling_method}#{edit_message(msg)}\n#{show_error_in_text}"
    end

    #
    def info(msg)
        calling_method = caller[0].match("`(.*)'")[1]
        puts "#{@cur_token.kind}(#{@cur_token.spelling}): caller=#{calling_method}#{edit_message(msg)}" if @verbose
    end
    
    #
    def edit_message(msg)
        message = ": msg=#{msg}" if !msg.empty?
    end
end


# Usage
if(__FILE__ == $0)

    str = "good&bye"
    str = "searchme ! andsdfsdf"
    puts str, ''
    scanner = Scanner.new(str)
    parser = Parser.new(scanner, true)
    parser.parse
    
end    
