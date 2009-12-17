require 'soap/wsdlDriver'
require 'cgi'

#~ http://www.google.com/apis/reference.html

class SearchGoogle

    def search(query)
        key = "Yx5k9P1QFHLrE2VXUxZY0cNI3XdzX91u"
        wsdlUrl = "http://api.google.com/GoogleSearch.wsdl"
        soap = SOAP::WSDLDriverFactory.new(wsdlUrl).createDriver
        result = soap.doGoogleSearch(
            key, query, 4, 10, false, nil, false, nil, nil, nil)

        printf("Estimated number of results: %d.\n", result.estimatedTotalResultsCount)
        printf("Your query took %6f seconds.\n", result.searchTime)
        printf("Search query: %s\n\n", result.searchQuery)
        #~ printf("Start/End index: %s-%s\n\n", result.startIndex, result.endIndex)

        results = result.resultElements
        result.resultElements.each_index { |idx|
            printf("%s: %s\n", idx, results[idx].title)
        }
        
        #~ first = result.resultElements[0]
        #~ puts first.title
        #~ puts first.URL
        #~ puts CGI.unescapeHTML(first.snippet)
    end
end

sg = SearchGoogle.new
sg.search("michele mendel")