#!/usr/bin/env ruby
require 'rubygems'
# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'

require "fileutils"

def zerofill(n,d)
  str=n.to_s
  i=d-str.size
  return str if i < 0
  z="0"
  zeros=""
  while i > 0
    zeros +=z if (1 == i & 1)
    z+=z
    i>>=1
end
return zeros+str
end

def read_ini
    fileName = "crawler.ini"
    dirName = File.expand_path(File.dirname($0))
    filePath = dirName + "/" + fileName
    uniqid = 0
    # read .ini file
    File.open(filePath, "r") do |file|
        file.each_line do |line|
            str = line.split("=")
            uniqid  = str[1].to_i
        end
    end
    return uniqid
end

def write_ini(uniqid)
    fileName = "crawler.ini"
    dirName = File.expand_path(File.dirname($0))
    filePath = dirName + "/" + fileName
    # rewrite .ini file
    f = File.open(filePath, "r")
    buffer = f.read()
    buffer = buffer.gsub(/[0-9]+/, uniqid.to_s)
    f = File.open(filePath, "w")
    f.write(buffer)
    f.close()
end

def save_image(url, image_id)
    # ready filepath
    fileName = image_id + ".jpg" #File.basename(url)
    print fileName + ", "

    dirName = File.expand_path(File.dirname($0))
    filePath = dirName + "/images/" + fileName

    # create folder if not exist
    FileUtils.mkdir_p(dirName) unless FileTest.exist?(dirName)

    # write image data
    File.open(filePath, 'wb') do |output|
        open(url) do |data|
            output.write(data.read)
        end
    end
end

def check_charcode(url)
    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
  end
  return html, charset
end

def crawl_imagepage(url)
    html, charset = check_charcode(url)
    # htmlをパース(解析)してオブジェクトを作成
    doc = Nokogiri::HTML.parse(html, nil, charset)

    tags = []
    doc.xpath('//li[@class="tag"]').each do |node|
        # title
        tag = node.css('a.text').inner_text
        tags.push(tag)
    end
    print tags
end

def crawl_toppage
    # スクレイピング先のURL
    top = 'http://www.pixiv.net/'

    # htmlをパース(解析)してオブジェクトを作成
    html, charset = check_charcode(top+'ranking.php')
    doc = Nokogiri::HTML.parse(html, nil, charset)

    uniqid = read_ini

    doc.xpath('//section[@class="ranking-item"]').each do |node|
        # 管理用のシステムidの取得
        uniqid += 1
        print zerofill(uniqid, 5) + ", "

        # 画像idの取得
        image_id = node.attribute('data-id').value
        print image_id + ", "

        # 予備情報の取得
        rank = node.css('h1').inner_text
        title = node.css('h2').inner_text

        # 記事のサムネイル画像のリンク
        url = node.css('img').attribute('data-src').value
        save_image(url, image_id)

        # labels (for men, for women)
        print "0, 0, "

        # リンクからタグ情報の取得
        link = node.css('div.ranking-image-item a').attribute('href').value
        crawl_imagepage(top+link)

        print "\n"
        #break
    end

    write_ini(uniqid)
end

# usage
# - ruby crawler.py > index_1-500.txt
# - 注意：

if __FILE__ == $0
    crawl_toppage
end





