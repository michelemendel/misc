#
# Fun with http://debatt.aftenposten.no/
# moderator:: http://debatt.aftenposten.no/adm/
# 
# Author:: Michele Mendel
# Date:: Oslo 2008-07-16
# 
# Hpricot
# See:: http://code.whytheluckystiff.net/hpricot/
# See:: http://code.whytheluckystiff.net/doc/hpricot/
# See:: http://code.whytheluckystiff.net/hpricot/wiki/InstallingHpricot


require 'pp'
require 'open-uri'
require 'hpricot'
require 'markaby'
require 'cgi'
require 'date'

@host = "http://debatt.aftenposten.no/"

#
def doc(url)
#    Hpricot.buffer_size = 262144 #(2^18) Not to run out of buffer space
    @url = @host + url
    return Hpricot::XML(open(@url))
end


# Raw page
def threads(group_id)
    url = 'thread.php' + group_id(group_id)
    doc(url)/"div.threadwrap"
end

# Raw page
def item(group_id, thread_id=nil, item_id=nil)
    url = 'item.php' + group(group_id) + thread_id(thread_id) + item_id(item_id)
    doc(url)
end

# Raw page
def search(group_id, search_string="", days=nil, user_name="", page=nil)
    url = "search.php" + 
        group(group_id) + 
        search_string(search_string) + 
        period(days) + 
        user(CGI.escape(user_name)) +
        page(page) +
        (page < 3 ? "" : "&TOPDOC=#{(page-2)*20}")
    doc(url)
end

# URL formatting
def group_id(id) "?GroupID=#{id}" end
def group(id) "?Group=#{id}&xGroup=#{id}" end
def search_string(str) "&P=#{str}&xP=#{str}" end
def user(un) un.empty? ? "" : "&Username=#{un}&xUsername=#{un}" end
def thread_id(id) id.nil? ? "" : "&ThreadID=#{id}" end
def item_id(id) id.nil? ? "" : "&ItemID=#{id}" end
def period(days) days.nil? ? "" : "&Start=#{days}" end
def search_id(id) id.nil? ? "" : "&ThreadID=#{id}" end
def page(p) p.nil? ? "" : "&Page=#{p}" end


#
def thread_entries(group_id, nof_entries=-1)
    ret = []
    nof_entries = nof_entries==-1 ? -1 : nof_entries-1
    threads(group_id)[0..nof_entries].each do |e|
        title = ((e/("div.threadscol41")/:a).inner_html)
        if(!title.empty?)
            line = {}
            line[:title] = title
            line[:author] = ((e/("div.threadscol42")/:a).inner_html)
            line[:nof_entries] = ((e/("div.threadscol43")).inner_html)
            line[:nof_views] = ((e/("div.threadscol44")).inner_html)
            line[:time] = ((e/("div.threadscol45")/:a).inner_html)
            ret << line
        end
    end
    ret
end

#
def search_hits(search)
    hits = 0
    elements = (search/"div/div/div")
    elements.each_index do |idx|
        if(idx == 2)
            els = elements[idx]/:div
            els.each_index do |idx|
                if(idx == 16)
                    return els[idx].inner_html.match(/.* treff/)[0]
                end
            end
        end
    end
end

# Getting entries from search
def user_entries(user, group_id, days, search_string)
    ret = []

    memo = ""
    page = 1
    loop do
        search = search(group_id,search_string,days,user,page)
        els = search/"div.table/div.rowcont-scalable/div.slistitemcol42"
        
        
        if(els[0].nil?)
            puts "No entries for user '#{user}' in group #{group_id} (search_string='#{search_string}', days=#{days})"
            break
        end
        print page
        remember = (els[0]/:a).to_html
        break if(remember == memo)
        memo = remember
        print ","

        els.each_index do |idx|
            m = ((els[idx]/"a").to_html.match(/ThreadID=(\d+).*ItemID=(\d+)/))
            title = ((els[idx]/:a).inner_html)
            entry = {}
            entry[:thread_id] = m[1]
            entry[:item_id] = m[2]
            entry[:title] = title
            ret << entry
        end
        page += 1
    end
    puts
    ret
end

#
def item_data(group_id, thread_id, item_id)
    re1 = /<a name="item#{item_id}"><\/a>(.*)fetch\(3,#{item_id}/m
    item = item(group_id,thread_id,item_id).inner_html
#    puts @url
    item = item.match(re1)
    entry_date,reply_to_name,reply_to_url,text, recommendations = "","","","",""
    if(item)
        item = item[1]
        entry_date = item_date(item)
        reply_to_name, reply_to_url = reply_to(item)
        recommendations = recommendations(item)
        text = item_text(item)
    else
        text = "Some problem. Comment or thread probably removed"
    end
    return text, entry_date, reply_to_name, reply_to_url, recommendations
end

# Extract text from item
def item_text(item)
    re1 = /<div class="box-2">.*?<\/div>/m
    re2 = /<span class="h3">(.*?)<\/span>/m
    text = ""
    text = item.sub(re1,'')
    text = text.match(re2)[1] unless text.nil?
    text
end

# Extract 'Svar til' from item
def reply_to(item)
    re1 = /Svar til: <a href="\/(item.php\?ItemID=\d+?&amp;ThreadID=\d+?)">(.*?)<\/a>/m
    rt = item.match(re1)
    if(rt.nil?)
        return ""
    else
        url = @host + rt[1].sub('&amp;','&')
        user = rt[2]
        return user,url
    end
    
end

# Extract date from item
def item_date(item)
    re1 = /<span class="h5">(\d\d\.\d\d\.\d\d)&nbsp;(\d\d:\d\d)<\/span>/m
    datetime_format = "%d.%m.%y %H:%M"
    
    date = item.match(re1)
    date = DateTime.strptime("#{date[1]} #{date[2]}", datetime_format) unless date.nil?
    date.nil? || date.to_s.empty? ? "" : date
end

# Extract nof 'Anbefalt av' from item
def recommendations(item)
    re1 = /Anbefalt av <span id="recom\d+cnt">(\d+)<\/span>/m
    item.match(re1)[1]
end


#
def user_items(group,user,days,search_string)
    entries = user_entries(user, group, days, search_string)
    items = []
    count = 1
    entries.each do |e|
        entry = {}
        entry[:title] = e[:title]
        entry[:text],entry[:date],entry[:reply_to_name],entry[:reply_to_url],entry[:recommendations] = item_data(group, e[:thread_id], e[:item_id])
        entry[:url] = @url
        items << entry
        print "."
        puts if(count%10==0)
        count += 1
    end
    puts "#{count} items"
    puts
    items
end

#
def user_items_to_html(user_items,group,user,days,search_string)
    mab = Markaby::Builder.new
    mab.html do
        tag!(:meta, 'http-equiv'=>'Content-Type', 'content'=>'text/html; charset=ISO-8859-1')
        head do 
            title "Aftenposten Debatt" 
            text("<link rel='stylesheet' href='../debatt.css' type='text/css'/>")
        end
        body do
            h1 "User '#{user}', group #{group}, days #{days}, search-string '#{search_string}' - #{user_items.size} entries"
            user_items.each do |ui|
                div.compact do
                    span.date(ui[:date].strftime('%Y.%m.%d %H:%M')) unless ui[:date].to_s.empty?
                    text(" ")
                    span.title(CGI.unescapeHTML(CGI.unescapeHTML(ui[:title])))
                end
                div.compact(a(ui[:url], :href => ui[:url]))
                div.compact("Anbefalt av " + ui[:recommendations]) if ui[:recommendations].to_i > 0
                div.compact("Svar til #{b(ui[:reply_to_name])} " + a(ui[:reply_to_url], :href => ui[:reply_to_url]))
                p.text(ui[:text])
            end
        end
  end
  CGI.unescapeHTML(mab.to_s)
end


def html_report(group, user, days, search_string)
    puts user
    user_items = user_items(group,user,days,search_string)
    html_str = user_items_to_html(user_items,group,user,days,search_string)
    File.open("debatt/#{user}_#{days}_#{search_string}.html",'w') {|f| f.write(html_str)}
end



if(__FILE__==$0)

    group = 28
    days = 365
    search_string = ""

    bad = %w{Querius skinnhellig Svod AD-Mett nic100 
             Antirasist2 Pisspreik C-4 H03 Karatel 
             tyttlason vitamino Gaute36 Sokrates05 siops 
             onkel43 lima pimpernell Havkatt Aicat
             Sokrates05 Storeulv Paladin}

    good = %w{zedix Haggay Goldwater Ariel36 Yehuda 
              hannah45 Arbat lusekoftan joh316 BjornD
              CoyoteBlue GoBi sv25 Masada Guns
              Ida mrfred Isidoro}

    dontknow = %w{DevNull Kulumuli vitamino Tøfflus jaffasin Seso
                  nemesis2005 sauraman Jesusmaria}
    
    testing = %w{Sledgehammer}
    
    idiot = %w{GNOMBOLT Olram}
    
    nohits = %w{Bjørnen1}
    
    testing.each do |user|
        html_report(group, user, days, search_string)
    end

end