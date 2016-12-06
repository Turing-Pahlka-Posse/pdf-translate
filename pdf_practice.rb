require 'pdf-reader'
require 'csv'
require 'pry'

reader = PDF::Reader.new("edu_data.pdf")

page_1 = reader.page(26)
page_2 = reader.page(27)
page_3 = reader.page(28)

@pages = [page_1, page_2, page_3]
# captures the headers
@pages.first.text.split("\n").find_all {|line| line != ""}[4].squeeze(" ").split(" ")
@pages.first.text.split("\n").find_all {|line| line != ""}[6].squeeze(" ").split(" ")

# captures the rows into an array
@pages = @pages.map {|page| page.text.split("\n").find_all {|line| line != ""}}

def clean_row(row)
  row.squeeze(" ").split(" ")
end

# cleans the rows
@pages = @pages.map {|page| page.map {|row| clean_row(row) } }
@pages.first.map {|row| row.map{|el| el.gsub(/\,/,"")}.join(",") }

# makes each page into its own
@pages.each_with_index do |page, i|
  File.write("edu_data_#{i}.txt", page.text)
end
