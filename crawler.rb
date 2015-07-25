require 'rubygems'
# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

# スクレイピング先のURL
url = 'http://www.pixiv.net/ranking.php'

charset = nil
html = open(url) do |f|
  charset = f.charset # 文字種別を取得
  f.read # htmlを読み込んで変数htmlに渡す
end

# htmlをパース(解析)してオブジェクトを作成
doc = Nokogiri::HTML.parse(html, nil, charset)

doc.xpath('//section[@class="ranking-item"]').each do |node|
  # title
  p node.css('h1').inner_text
  p node.css('h2').inner_text
  # 記事のサムネイル画像
  p node.css('img').attribute('data-src').value
  # 記事のサムネイル画像
  #p node.css('a').attribute('href').value
end