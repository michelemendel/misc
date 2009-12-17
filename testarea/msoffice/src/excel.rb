require 'win32ole'
require 'pp'

# Connect to an already open Excel application
def connect_to_excel
    excel = WIN32OLE.connect('excel.application')
    excel.visible = true
    return excel
end

# Select workbook to work on, and save when done
def workbook(file, &wb)
    @excel ||= connect_to_excel
    workbook = @excel.workbooks.open(file)
    wb.call(workbook)
    res = workbook.save()
end


module ExcelConsts
end

def print_excel_constants
    excel = WIN32OLE.new("Excel.Application")
    WIN32OLE.const_load(excel, ExcelConsts)
    excel.quit()

    # m = "down"
    # puts 'Matches for: ' + m
    ExcelConsts.constants.each {|const|
        # match = const.match(/#{m}/)
        value = eval("ExcelConsts::#{const}")
        puts ' '*4 + const + ' => ' + value.to_s #unless match.nil?
    }
end


@file = 'C:/MM/Dev/Ruby/testarea/msoffice/scrum.xls'
@worksheet = 'Ark3'

workbook(@file) do |wb|
    sheet = wb.worksheets(@worksheet)
    sheet.select
    cs = sheet.range("a2").value = 123
    # cs.offset(1,0).value = 456
    sheet.range("a1:q200").value = ""
    # sheet.range("a1").select
    # sheet.range("a3").value = ""
end



