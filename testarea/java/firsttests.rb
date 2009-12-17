require 'sample'
require 'pp'

@m = Regexp::MULTILINE
@i = Regexp::IGNORECASE

def getPackage(code)
    re = /package\s+([\w\.]+)\s*;/m
    m = code.match(re)
    rest = code.sub(re,"")
    ret = m==nil ? "" : m[1]
    return ret, rest
end

def getImports(code)
    re = /import\s+([\w\.]+)\s*;/m
    
    ret = []
    code.scan(re) do |el|
        ret << el==nil ? "" : el[0]
    end
    rest = code.gsub(re,"")
    return ret, rest
end

def getPublicClass(code)
    re = /public class (.*?) \{(.*)\}/m
    ret = code.match(re)

    name = ret[1]==nil ? "" : ret[1].strip
    rest = ret[2]==nil ? "" : ret[2].strip
    return name, rest
end

def getPublicContructors(className, code)
    reString = "public\\s+#{className}\\s*\\(([\\w\\s,]*)\\)\\s+\\{(.*?)\\}"   
    reStringClean = "public\s+#{className}.*?\\}"

    re = Regexp.new(reString, @m|@i)    
    reClean = Regexp.new(reStringClean, @m)

    params, body = [], []
    code.scan(re) do |el|
        params << el[0]==nil ? "" : el[0].strip!
        body << el[1]==nil ? "" : el[1].strip!.delete!(";")
    end
    
    rest = code.gsub(reClean,"")

    return params, body, rest
end

def getPublicMethods(code)
    reString = "public\\s+(.+?)\\s+\\(([\\w\\s,]*)\\)\(\) \{(.*?)\}"
    reString = "public\\s+(.+?)\\s+\\(([\\w\\s,]*)\\)\(\) \{(.*?)\}"
    re = Regexp.new(reString, @m|@i)
    pp re
    
    returnVals, params, body = [],[],[]
    code.scan(re) do |el|
    
    end
    
    #~ p ret
    #~ return ret[1], ret[2]
end



# TEST

code = $sampleCode2

package, rest = getPackage(code)
#~ puts "package #{package}"

imports, rest = getImports(rest)
#~ imports.each{|i| puts "import #{i}"}

name, rest = getPublicClass(rest)
#~ puts "Class #{name}"

params, body, rest = getPublicContructors(name, rest)
#~ params.each{|e| puts "Constr. param #{e}"}
#~ body.each{|e| puts "Constr. body #{e}"}
puts rest

#~ returns, params, body, rest = getPublicMethods(body)