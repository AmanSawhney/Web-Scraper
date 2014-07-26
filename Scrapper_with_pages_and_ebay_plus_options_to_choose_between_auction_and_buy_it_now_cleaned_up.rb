
require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'pry'
class Object_oriented_scrape
  def initialize
    @agent = Mechanize.new
    puts "Which site would like, Amazon or Ebay"
    @site = gets.chomp.downcase
    if @site == "amazon"
      amazon
    else
      ebay
    end
  end
  def site(site_rake)
    @site = site_rake
  end
  def search(type_search)
    if type_search=="Amazon"
      page = @agent.get("http://Amazon.com")
      search_form = page.form_with(name: "site-search")
    else type_search == "Ebay"
      page = @agent.get("http://Ebay.com")
      search_form = page.form_with(action: "http://www.ebay.com/sch/i.html")
    end
    search_field = search_form.field_with(type: "text")
    puts "What product would you like to scrape"
    seach_value = gets.chomp
    search_field.value = "#{seach_value}"
    @page = search_form.submit
    @siturl = @page.uri
  end
  def print_reslut(type_result)
    if type_result == "Amazon"
      doc = Nokogiri::HTML(open("#{@page.uri}"))
        doc.css("div [class = 'rslt prod celwidget']").each do |el|
          puts name = el.css("span [class = 'lrg bold']").text
          puts price = el.css("span [class = 'bld lrg red']").text
        end
    else type_result == "Ebay"
      doc = Nokogiri::HTML(open("#{@page.uri}"))
        doc.css("table [class = 'li rsittlref ']").each do |el|
          puts name = el.css("a [class= 'vip ']").text.strip.gsub("Newly Listed","")
          puts price = el.css("span [style='color:#']").text.strip
            if @choice == "both"
              puts el.css("div[class='bin']").text.strip
              puts el.css("div[class='bids']").text.strip
              puts el.css("div[class='or Best Offer']").text.strip
            elsif @choice == "buyitnow"
              puts el.css("div[class='or Best Offer']").text.strip
            else @choice == "autions"
              puts el.css("div[class='bids']").text.strip
            end
          end
      end
  end
  def page_change(page_change)
    if page_change == "Amazon"
      puts "How many pages would you like to scrape"
      page_count = gets.chomp.to_i
      while page_count !=0
        print_reslut("Amazon")
        next_page = @page.at("a[title='Next Page']")
        @page = @agent.click(next_page)
        page_count = page_count-1
      end
    else
      puts "How many pages would you like to scrape"
      page_count = gets.chomp.to_i
      while page_count !=0
        if @choice == "autions"
          autions_button = page.at("a[title = 'Auction']")
          page = @agent.click(autions_button)
        elsif @choice == "buyitnow"
          bin_button = page.at("a[title = 'Buy It Now']")
          page = @agent.click(bin)
        else
          @choice = "both"
        end
        print_reslut("Ebay")
        next_page = @page.at("a[title='Next page of results']")
        @page = @agent.click(next_page)
        page_count = page_count-1
      end
    end
  end
  def amazon
    search("Amazon")
    page_change("Amazon")
  end
  def ebay
    search("Ebay")
    puts "Would you like to search Autions, Buy It Now, or Both"
    @choice = gets.chomp.downcase.strip
    page_change("Ebay")
  end

end
Start = Object_oriented_scrape.new()




