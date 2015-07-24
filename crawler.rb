require 'rubygems'
require 'nokogiri'
require 'open-uri'

url = "http://news.yahoo.co.jp/"
doc = Nokogiri::HTML(open(url))

for i in 1..8 do
	top_news_css = "li:nth-child(" + i.to_s + ") div"
	puts doc.at_css(top_news_css).text
end