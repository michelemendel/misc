# API for MKS
# 
# NOTE:: This should maybe be converted to a module or static methods.
# 
# Author:: Michele Mendel
# Date:: Oslo 2007-10-31
#

require 'pp'
 
class MKS
    attr_accessor :verbose
    
    # Field sets for Integrity Manager
    FS1 = "ID,State,Title,Release name,External Ref No,Customer,Contact person,Created By,Created Date,Assigned User,Change Type,Forward Relationships,Backward Relationships"
    FS2 = "ID,State,Title,Release name,External Ref No,Customer,Contact person,Created By,Created Date,Assigned User,Change Type,Description"
    FS3 = "ID,State,Title,Release name,External Ref No,Customer,Contact person,Created By,Created Date"
    FS4 = "ID"
    
    FORWARD = "Forward Relationships"
    BACKWARD = "Backward Relationships"
    DELIMITER = '##'
    FIELDS_DELIMITER = "--fieldsDelim='#{DELIMITER}'"
    
    TEMP_COLUMNSET = 'tmp_cs'
    DUMMY_CR = 21791
        
    # If MKS is installed, and MKS is set to remember username and password, 
    # this is not needed.
    def initialize(un="", pw="", host="mks", verbose=false)
        @host = "--hostname=#{host}"
        @un = "--user=#{un}"
        @pw = "--password=#{pw}"
        @verbose = verbose
    end
	
    # The call to the MKS CLI.
    def call_mks(cmd)
        exec_line = "im #{cmd}"
        puts exec_line if verbose
        `#{exec_line}`
    end
	
    # Se method initialize.
    def connect
        call_mks("connect #{@host} #{@un} #{@pw}")
    end
	
    # 
    def disconnect
        call_mks("disconnect --noconfirm")
    end
    
    #
    def get_column_names(field_set=FS1)
        field_set.split(',')
    end

    #
    def get_issue_ids(query)
        ids = call_mks("issues --fields='ID' --sortField='ID' --query='#{query}'")
        ret = []
        ids.each {|id| ret << id.chomp}
        ret
    end

    # Returns an issue as a hash.
    def get_issue(issue_id, field_set=FS1)
        issue_id = issue_id.to_s.chomp
        item = call_mks("issues --fields='#{field_set}' #{FIELDS_DELIMITER} #{issue_id}")
        
        issue = {}
        if(item)
            keys = get_column_names(field_set)
            vals = item.chomp.split(DELIMITER)
            vals.each_index {|idx| issue[keys[idx]] = vals[idx] }
        end
        return issue
    end

    # Returns a set of issues as an array of hashes.
    # This is the slowest of the three, but the safest.
    def get_issues(query, fields=FS1)
        ids = get_issue_ids(query)

        issues = []
        ids.each do |issue_id|
            issues << get_issue(issue_id, fields)
        end
		
        return issues
    end

    # Returns a set of issues as an array of hashes.
    # NOTE! There may be problems using this method. A string is truncated
    # if it's to long.
    def get_issues2(query, field_set=FS1)
        list = call_mks("issues --fields='#{field_set}' --query='#{query}' #{FIELDS_DELIMITER}")
        issues = []
        list.each do |item|
            issue = {}
            keys = get_column_names(field_set)
            vals = item.chomp.split(DELIMITER)
            vals.each_index {|idx| issue[keys[idx]] = vals[idx] }
            issues << issue
        end
        return issues
    end
    
    # Returns an issue as a hash.
    # Uses "viewissue", which can return all the data from an issue, but this
    # method doesn't have the flexibility with fields as the others.
    # Use this if you need data like cp and relationships in one call instead of 
    # multiple calls as with the other methods.
    def get_issue_full(issue_id)
        raw = view_issues(issue_id)
        parse_raw_issue_data(raw).first
    end
    
    # Returns a set of issues as an array of hashes.
    # Uses "viewissue", which can return all the data from an issue, but this
    # method doesn't have the flexibility with fields as the others.
    # Use this if you need data like cp and relationships in one call instead of 
    # multiple calls as with the other methods.
    def get_issues_full(query)
        ids = get_issue_ids(query).join(' ')
#        ids = '27076 27163 27180 27181'
        raw = view_issues(ids)
        parse_raw_issue_data(raw)
    end
    
    # Returns a set of issues as an array of hashes.
    def parse_raw_issue_data(raw)
        issues = []        
        issue = {}
        relationships = []
        end_of_issue = false
        
        raw.each do |line|
            case line
                when /^ID: +(.+?)$/
                    issue["ID"] = Regexp.last_match(1)
                when /^State: +(.*)$/
                    issue["State"] = Regexp.last_match(1)
                when /^Assigned User: +(.*)$/
                    issue["Assigned User"] = Regexp.last_match(1)
                when /^Release name: +(.*)$/
                    issue["Release name"] = Regexp.last_match(1)
                when /^Title: +(.*)$/
                    issue["Title"] = Regexp.last_match(1)
                when /^Implementation By: +(.*)$/
                    issue["Implementation By"] = Regexp.last_match(1)
                when /^Change Request (.*)/
                    relationships << Regexp.last_match(1)
                when /^Change Packages: +(.+?)$/
                    end_of_issue = true
                    next #get next line to check if there is a cp
            end
            
            if(end_of_issue)
                issue["cp"] = line.match(/\d+:1/) ? 'y' : 'n'
                issue["Relationships"] = relationships
                issues << issue
                
                # Reset variables
                issue = {}
                issue["cp"] = 'n'
                relationships = []
                end_of_issue = false
            end
        end
        
        return issues
    end

    # Returns one or more issues, based on issue_id:s Used to get Relationships,
    # history...
    def view_issues(issue_ids, show_cp=true, show_relationships=true, show_history=false, show_attachments=false)
        sa = show_attachments ? '--showAttachments' : '--noshowAttachments'
        sc = show_cp ? '--showChangePackages' : '--noshowChangePackages'
        sh = show_history ? '--showHistory' : '--noshowHistory'
        sr = show_relationships ? '--showRelationships' : '--noshowRelationships'
        te = '--noshowTimeEntries'
        hi = '--noshowHistory'
        cf = '--noshowHistoryWithComputedField'
        ba = '--batch'
        call_mks("viewissue #{sa} #{sc} #{sh} #{sr} #{te} #{hi} #{cf} #{ba} #{issue_ids}")
    end

    #
    def clean_empty_vals_from_hash(issue)
        issue.delete_if { |key,value| value == "" }
    end

    #
    def make_query(release_name)
        query_name = "tmptempquery"
        delete_query(query_name)
        system = "/Mellomvare & Mastere/COS"
        query_def = %Q[((field[System]="#{system}")and(field["Release name"]="#{release_name}"))]
        call_mks(%Q[createquery --name=#{query_name} --querydefinition=#{query_def}])
        return query_name
    end
    
    #
    def delete_query(query)
        call_mks("deletequery --noconfirm #{query}")
    end
    
    #
    def has_cp?(issue_id)
        call_mks("cps #{issue_id}") != ""
    end
    
    #
    def has_relationship?(issue)
        issue.has_key?(FORWARD) || issue.has_key?(BACKWARD)
    end
    
    # Returns an array of relationship id:s
    def get_relationships(issue)
        rels = []
        rels.concat(issue[FORWARD].split(/, /)) if issue[FORWARD]
        rels.concat(issue[BACKWARD].split(/, /)) if issue[BACKWARD]
        rels
    end
    
    #
    def get_highest_issue_id
        get_issue_ids("Everything").last
    end
    
    
    # ftc = fields_to_change
    def edit_issue(issue_id, *ftc)
        fields_to_change = []
        ftc.pop.each{ |k,v| fields_to_change << "--field='#{k}=#{v}'" }
        call_mks("editissue #{fields_to_change.join(' ')} #{issue_id}")
    end
	
    # 
    def get_queries
        call_mks("queries")
    end
	
    # 
    def view_query(query)
        call_mks("viewquery '#{query}'")
    end
	
    # 
    def get_reports
        call_mks("reports")
    end
	
    # 
    def help(command)
        call_mks("#{command} --usage")
    end
	
    # 
    def about
        call_mks("about")
    end
end




# Manuella tester
if(__FILE__ == $0)
	
    @mks = MKS.new("t539714")
    @mks.verbose = false

    def test_queries
        # @mks.show_queries
        @mks.view_query('COS24')
    end
    
    def test_get_issue_ids
        ids = @mks.get_issue_ids("COS24.0 Bugfix - all")
        ids.each {|id| puts "¤#{id}¤"}
    end
    
    def test_get_issue
        shadow_set = "ID,Implementation By,Assigned User,State,Title,Release name,Forward Relationships,Backward Relationships"
        pp @mks.get_issue("28091", shadow_set)
#        puts "-"*20
#        pp @mks.get_issue(27016, shadow_set)
    end
    
    def test_get_issue_full
#        26974, 26899
        res = @mks.get_issue_full("28043")
        pp res
    end

    def test_get_issues
        shadow_set = "ID,Implementation By,Assigned User,State,Title,Release name,Forward Relationships,Backward Relationships"
        query = "COS24.0 Bugfix - all"
        res = @mks.get_issues(query, shadow_set)
#        pp res
    end
    
    def test_get_issues2
        res = @mks.get_issues2("COS24.0 Bugfix - all")
        pp res
    end
    
    def test_get_issues_full
        res = @mks.get_issues_full("COS24.0 Bugfix - all")
        pp res
    end

    def test_view_issues
        res = @mks.view_issues("25550 28091")
        puts res
    end

    def test_get_relationships
        res = @mks.get_relationships(21081)
        # puts res
    end

    def test_has_cp
        puts @mks.has_cp?(3362) # true
        puts @mks.has_cp?(21330) # false
        puts @mks.has_cp?(27448) # true
        
    end
    
    def test_make_query
        q = @mks.make_query("COS 25.0")
        pp @mks.get_issues(q)
        pp q
#        @mks.view_query(qn)
    end
    
    def test_get_highest_issue_id
        pp @mks.get_highest_issue_id
    end
    
    def test_edit_issue
        @mks.edit_issue(
            MKS::DUMMY_CR,
            :State => 'Initial Analysis',
            :'Estimated hours' => 13,
            :'External Ref No' => 555255
        )
    end


# test_queries 

# test_get_issue
 test_get_issue_full

# test_get_issues
# test_get_issues2
 test_get_issues_full
# 
# test_view_issues
# test_get_issue_ids
# test_has_cp
# test_get_relationships
# test_make_query
# test_get_highest_issue_id
# test_edit_issue

end #if(__FILE__ == $0)


