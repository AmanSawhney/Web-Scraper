require 'rubygems'
require 'mechanize'
require 'open-uri'
class Object_oriented_scrape
  def initialize
    @agent = Mechanize.new
    puts "Which site would like, Amazon or Ebay"
    @site = gets.chomp
    if @site == "Amazon"
      amazon_Search
    end
  end
  def amazon_Search
    page = @agent.get("http://Amazon.com")
    search_form = page.form_with(name: "site-search")
    search_field = search_form.field_with(type: "text")
    puts "What product would you like to scrape"
    seach_value = gets.chomp
    search_field.value = "#{seach_value}"
    page = search_form.submit
    doc = Nokogiri::HTML(open("#{page.uri}"))
      doc.css("div [class = 'rslt prod celwidget']").each do |el|
        puts name = el.css("span [class = 'lrg bold']").text
        puts price = el.css("span [class = 'bld lrg red']").text
      end
end
end
Start = Object_oriented_scrape.new()
