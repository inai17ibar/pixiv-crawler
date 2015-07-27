#!/usr/bin/env ruby
require 'rubygems'
# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'
require "kconv"
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
    fileName = image_id + ".jpg"
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

def save_multi_image(url, image_id, cnt)
    # ready filepath
    fileName = image_id + "_p" + cnt.to_s + ".jpg"
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

def crawl_imagepage(url, image_id)

    html, charset = check_charcode(url)
    doc = Nokogiri::HTML.parse(html, nil, charset)
    #top = "http://www.pixiv.net/"

    # タグの取得
    tags = []
    doc.xpath('//li[@class="tag"]').each do |node|
        tag = node.css('a.text').inner_text
        tags.push(tag)
    end
    print tags

    # 大きな画像の保存
    node = doc.xpath('//div[@id="wrapper"]')
    node.css('img').each do |sub_node|
        link = sub_node.attribute('src').value
        if link.include?("600x600")
            print link
            #save_image(link, image_id)
        end
    end

=begin
    p 'get wrapper'
    node = node.gsub("/<script>(.*?)<\/script>/i", "")
    print node
    mlt_link = ""
    mlt_link = doc.css('a') #'div._layout-thumbnail.ui-modal-trigger'
    if mlt_link!=nil
        print mlt_link[2]
    end

    # div[@id="wrapper"][@class="layout-a"]/div
    doc.xpath('//img').each do |node|
        print node
        #node1 = node.css('div.works_display img').attribute('src').value
        #print node1
    #単ページ
    if mlt_link == nil
        sub_url = node.css('img').attribute('src').value
        save_image(top + sub_url, image_id)
    end
    #複数ページ
    if mlt_link != nil
        html, charset = check_charcode(top + mlt_link)
        sub_doc = Nokogiri::HTML.parse(html, nil, charset)
        cnt = 0
        sub_doc.xpath('//div[@class="item-container"]').each do |sub_node|
            sub_url = sub_node.css('img.image.ui-scroll-view').attribute('data-src').value
            save_multi_image(top + sub_url, image_id, cnt)
            cnt += 1
        end
    end
end
=end

end

def crawl_toppage(top)
    # htmlをパース(解析)してオブジェクトを作成
    html, charset = check_charcode(top+'ranking.php?mode=male') #'ranking.php'
    doc = Nokogiri::HTML.parse(html, nil, charset)

    uniqid = read_ini

    doc.xpath('//section[@class="ranking-item"]').each do |node|
        # 管理用のシステムidの取得
        uniqid += 1
        print zerofill(uniqid, 5) + ", "

        # 画像idの取得
        image_id = node.attribute('data-id').value
        print image_id + ", "

        # ユーザidの取得
        user_id = node.css('a.user-container.ui-profile-popup').attribute('data-user_id').value
        print user_id + ", "

        # 画像登録日
        date = node.attribute('data-date').value
        print date + ", "

        # 予備情報の取得
        #rank = node.css('h1').inner_text
        #title = node.css('h2').inner_text

        # 記事のサムネイル画像のリンク
        #url = node.css('img').attribute('data-src').value
        #save_image(url, image_id)

        # labels (for men, for women)
        print "0, 0, "

        # リンクからタグ情報の取得
        link = node.css('div.ranking-image-item a').attribute('href').value
        #print top+link
        crawl_imagepage(top+link, image_id)

        print "\n"
        #break
    end
    write_ini(uniqid)
end

# usage
# - ruby crawler.py > index_1-500.txt
# - 注意：

if __FILE__ == $0
    # スクレイピング先のURL
    top_url = "http://www.pixiv.net/"
    crawl_toppage(top_url)
end