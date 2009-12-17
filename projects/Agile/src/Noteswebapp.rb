require 'pp'
require 'camping'
require 'notes'

Camping.goes :Noteswebapp


def current_dir
    File.expand_path(File.dirname(__FILE__))
end


############################## CONTROLLERS ##############################

module Noteswebapp::Controllers
  
    class Index < R '/'
        def get
            @releases = Notes.releases
            render :index
        end        
    end
    
    class List < R '/list/(.+)/(.+)'
        def get(release, sprint)
            query = Notes.releases[release]["query"]
            @issues = Notes.get_issues(query,sprint)
            render :list_issues
        end        
    end
    
    class Print < R '/print/(.+)'
        def get(ids)
            @issues = Notes.get_issues_from_ids(ids)
            render :show_notes
        end
    end
    
    # Resources #
    #
    class Sorttable < R '/sorttable.js'
        def get
            File.read('sorttable.js')
        end
    end
    
    #
    class Stylesheet < R '/.+\\.css'
        def get
            @headers["Content-Type"] = "text/css; charset=utf-8"
            File.read("#{current_dir}/MKS_CR.css")
        end
    end
    
end



############################## VIEWS ##############################

module Noteswebapp::Views
    TEMPLATE = File.read("#{current_dir}/MKS_CR.template")
    HEADERS = ["CR","Release","Sprint","Theme","Title","Customer","Contact","est dev","est test","est tot","etc dev","etc test","used"]
    KEYS_LIST = ["ID","Release name","sprint","theme","Title","Customer","Contact person","estdev","esttest","esttot","etcdev","etctest","used"]
    KEYS_NOTES = ["ID","Release name","sprint","theme","Title","Description","Customer","Contact person","estdev","esttest","esttot","etcdev","etctest","etctot","used"]
    THEME_COLOR = ["fff","000"]
    THEME_BGCOLOR = ["3a3","ee3"]
    #
    def layout
        html do
            head do
                title 'Scrum Notes from MKS Change Request'
                link :href => R(Stylesheet), :rel => 'stylesheet', :type => 'text/css'
            end
            body { self << yield }
        end
    end
    
    #
    def index
        h2 {'Select sprint'}
        @releases.each do |release, vals|
            span(:class => "bold") do 
                p(release)
                text("Sprint: ")
            end
            vals["sprints"].each do |sprint|
                text(a(sprint, :href => R(List, release, sprint)) + " ")
            end
        end
    end
    
    #
    def list_issues
        p { a("Back to main", :href => R(Index)) }
        ids = @issues.map { |issue| issue["ID"] + "," }
        p { a("Print all", :href => R(Print, ids)) }
                
        table.list do
            #header
            tr.list { HEADERS.each_index { |key| th.list {HEADERS[key]} } }        
            #body
            @issues.each do |issue|
                tr.list do
                    KEYS_LIST.each { |key| td.list {issue[key]} }
                end
            end
        end
    end
    
    #
    def show_notes
        notes = ""
        @issues.each { |issue| notes << make_note(issue) + "<p/>" }
        
        table.main { tr.main { td.main {notes}}}
        notes
    end
    
    #
    def make_note(issue)
#        template = TEMPLATE.dup
        note = File.read("#{current_dir}/MKS_CR.template")
        
        #Theme color
        if(c = issue["sprint"])
            c = c.strip.to_i - 1
            set_in_note(note, "theme_color", THEME_COLOR[c])
            set_in_note(note, "theme_bgcolor", THEME_BGCOLOR[c])
        end
        
        KEYS_NOTES.each { |key| issue[key] = "n/a" if(!issue.has_key?(key) || issue[key] == "") }
        issue["Description"] = truncate(issue["Description"])
        issue["ID"] = "CR" + issue["ID"]
        issue["sprint"] = "Sprint " + issue["sprint"]
        issue.each { |key, val| set_in_note(note, key, val) }
        
        return note
    end
    
    #
    def set_in_note(note, key, val)
        note.sub!(/%#{key}%/, val)
    end
    
    #
    def truncate(txt)
        if txt.count(' ') >= 80
            m = txt.match(/(.+? ){80}/m)[0] + "..."
        else
            m = txt
        end
        return m
    end

    #
    def do_link(issue)
        a(issue, :href => "http://mks:7001/im/viewissue?selection=#{issue}")
    end
    
    #
    def do_td_div(level_val, str)
        td(:class => "level#{level_val}") do str end
    end
    
end


############################## HELPERS ##############################

#module Noteswebapp::Helpers    
#    def current_dir
#        File.expand_path(File.dirname(__FILE__))
#    end
#end
