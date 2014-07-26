
require 'rubygems'
require 'mechanize'
require 'open-uri'
require 'pry'


class ObjectOrientedScrape
  def initialize(site_name_web, search_web, ebay_choice_web, number_of_pages_web, page_change_site)
    @agent = Mechanize.new
    puts "Which site would like, Amazon or Ebay"
    @site = site_name_web.downcase.strip 
    @search_web =search_web.downcase.strip 
    @ebay_choice_web = ebay_choice_web.downcase.strip 
    @number_of_pages_web = number_of_pages_web.to_i
    @page_change_site = page_change_site.downcase.strip 
    if @site == "amazon"
      amazon
    else
      ebay
    end
  end
  def search(type_search)
    if type_search=="amazon"
      page = @agent.get("http://Amazon.com")
      search_form = page.form_with(name: "site-search")
    else type_search == "ebay"
      page = @agent.get("http://Ebay.com")
      search_form = page.form_with(action: "http://www.ebay.com/sch/i.html")
    end
    search_field = search_form.field_with(type: "text")
    puts "What product would you like to scrape"
    seach_value = @search_web
    search_field.value = "#{seach_value}"
    @page = search_form.submit
    @siturl = @page.uri
  end
  def print_result(type_result)
    @array_buy_it = []
    @array_bids = []
    if type_result == "Amazon"
      @array_of_products = Array.new
      @array_of_prices = Array.new
      doc = Nokogiri::HTML(open("#{@page.uri}"))
        doc.css("div [class = 'rslt prod celwidget']").each do |el|
          name = el.css("span [class = 'lrg bold']").text
          price = el.css("span [class = 'bld lrg red']").text
          puts name
          puts price
          @array_of_products.push(name)
          @array_of_products.push(price)
        end
    else type_result == "Ebay"
      doc = Nokogiri::HTML(open("#{@page.uri}"))
        @array_of_products = Array.new
        @array_of_prices = Array.new
        doc.css("table [class = 'li rsittlref ']").each do |el|
           name = el.css("a [class= 'vip ']").text.strip.gsub("Newly Listed","")
           price = el.css("span [style='color:#']").text.strip
           @array_of_products.push(name)
           @array_of_products.push(price)
            if @choice == "both"
              bin = el.css("div[class='bin']").text.strip
              bids = el.css("div[class='bids']").text.strip
              bo= el.css("div[class='or Best Offer']").text.strip
              @array_of_products.push(bin)
              @array_of_products.push(bids)
              @array_of_products.push(bo)
            elsif @choice == "buyitnow"
              bin = el.css("div[class='bin']").text.strip
              bids = el.css("div[class='bids']").text.strip
              @array_of_products.push(bin)
              @array_of_products.push(bids)
            else @choice == "autions"
              bids = el.css("div[class='bids']").text.strip
              @array_of_products.push(bids)
            end
          end
      end
  end
  def name_of_product  
    @array_of_products
  end
  def page_change(page_change)
    if page_change == "amazon"
      puts "How many pages would you like to scrape"
      page_count = @number_of_pages_web
      while page_count !=0
        print_result("Amazon")
        next_page = @page.at("a[title='Next Page']")
        @page = @agent.click(next_page)
        page_count = page_count-1
      end
    else page_change == "ebay"
      puts "How many pages would you like to scrape"
      page_count = @number_of_pages_web
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
        print_result("Ebay")
        next_page = @page.at("a[title='Next page of results']")
        @page = @agent.click(next_page)
        page_count = page_count-1
      end
    end
  end
  def amazon
    search(@site)
    page_change(@page_change_site)
  end
  def ebay
    search(@site)
    puts "Would you like to search Autions, Buy It Now, or Both"
    @choice = @ebay_choice_web
    page_change(@page_change_site)
    if @choice != nil
    end
  end

end




# Start = ObjectOrientedScrape.new("Ebay", "PRS", "Both", "2", "Ebay")