require 'rubygems'
require 'mechanize'
require 'open-uri'
agent = Mechanize.new
page = agent.get("http://ebay.com")
search_form = page.form_with(action: "http://www.ebay.com/sch/i.html")
search_field = search_form.field_with(type: "text")
search_field.value = "prs"
page = search_form.submit
puts page.uri




