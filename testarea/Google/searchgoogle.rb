require 'google'
require 'cgi'

#http://www.google.com/apis/reference.html

class SearchGoogle
    include Google

    def search(searcrhStr)
        key = "Yx5k9P1QFHLrE2VXUxZY0cNI3XdzX91u"
        google = Search.new(key)
        result = google.search(searcrhStr)
        
        printf("Estimated number of results: %d.\n", result.estimatedTotalResultsCount)
        printf("Your query took %6f seconds.\n", result.searchTime)
        printf("Search query: %s\n", result.searchQuery)
        #~ printf("Start/End index: %s-%s\n\n", result.startIndex, result.endIndex)
        
        first = result.resultElements[0]
        puts first.title
        puts first.URL
        puts CGI.unescapeHTML(first.snippet)
    end
end

sg = SearchGoogle.new
sg.search("yamaha CRW3200E")