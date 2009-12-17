# 
# 
# 
 
require 'pp'
require 'mks'

module Notes
    # NOTE! No spaces in sets
    MAIN_SET = "ID,Title,Release name,Description,Customer,Contact person,Comments"
    MKS = MKS.new
    
    #
    def Notes.releases
        YAML.load(File.open("releases.yml"))
    end
    
    #
    def Notes.get_issues(query, sprint)
        puts "Query=#{query}, sprint#{sprint}"
        MKS.get_issues(query, MAIN_SET)
    end
    
    #
    def Notes.get_issues_from_ids(ids)
        ids_array = ids.split(',')
        issues = []
        ids_array.each do |id|
            issues << enrich_issue(MKS.get_issue(id, MAIN_SET))
        end
        return issues
    end
    
    # Enrich issue with sprint, theme, est(dev,test,tot), etc(dev,test,tot), used, 
    #<<< SPRINT DATA - DO NOT REMOVE >>>
    #sprint 1 
    #theme "Robust COS" 
    #estdev 22 esttest 3333  
    #etcdev 1 etctest 3
    #used 12 
    #<<< SPRINT DATA - DO NOT REMOVE >>>
    def Notes.enrich_issue(issue)
        number_keys = ["sprint", "estdev","esttest","etcdev","etctest","used"]
        re = />>>(.*?)<<</m
        
        txt = issue["Comments"]
        m = txt.match(re) if txt
        if(m)
            m = m[1].strip

            number_keys.each do |key|
                val = m.match(/#{key} *(\d+) */)
                issue[key] = val ? val[1] : ""
            end

            val = m.match(/theme *"(.+?)" */)
            issue["theme"] = val ? val[1] : ""

            issue["esttot"] = (issue["estdev"].to_i + issue["esttest"].to_i).to_s
            issue["etctot"] = (issue["etcdev"].to_i + issue["etctest"].to_i).to_s
        end
        
        return issue
    end

end


if(__FILE__ == $0)
    
    #test get_issues
#    query = "COS24.0 Bugfix - all"
    #query = "COS25.0 (All Issues)"
    
#    issues = Notes.get_issues(query, 1)
#    issues.each do |issue|
#        puts "#{issue["ID"]}, #{issue["Title"]}, #{issue["Release name"]}, #{issue["Customer"]}, #{issue["Contact person"]}, #{issue["Comments"]}"
#    end
    
    
    #test get_issues_from_ids
    ids = "26899,26974,27016,27524,27557,27558,"
    res = Notes.get_issues_from_ids(ids)
    pp res
    
end