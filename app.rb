require 'bundler'
Bundler.require
require './lib/Scrapper_with_pages_and_ebay_plus_options_to_choose_between_auction_and_buy_it_now_cleaned_up.rb'

get '/' do 
  erb :form
end

post '/' do 
 
  @new_search= ObjectOrientedScrape.new(params[:site], params[:Search], params[:Ebay_choice], params[:Pages], params[:site])
  @site = params[:site]
  @products = @new_search.name_of_product
  erb :results
end
