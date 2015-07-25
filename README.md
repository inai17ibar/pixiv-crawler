# pixiv-filtering

#### 概要


#### 保存するindexファイルの構造

* indexファイルは名前をつけるようにする。
- 例：index_1-1000.txt

```
id, image_id, image_filename, for_men_labal, for_woman_labal, [tag1, tag2, ...]

```

id ...

image_id ...

image_filename ...

for_men_labal ...

for_woman_labal ...

tags ... 


#### 追加したい機能

* 重複画像のチェック
* ランキングページの下までを自動で読み込む
* 下のいろんなランキングページのクローリングに対応
* 定期的に実行されるスクリプト

#### 取得する元のURLについて

- ランキングページを使用する．
* http://www.pixiv.net/ranking.php
* 以下、細かいランキングページも存在する．

```
pixiv.text.today = '本日';
pixiv.text.yesterday = '昨日';
pixiv.text.notifications = 'メッセージ・ポップボード';

pixiv.text.dailyRanking = 'デイリーランキング';
pixiv.text.weeklyRanking = 'ウィークリーランキング';
pixiv.text.monthlyRanking = 'マンスリーランキング';
pixiv.text.rookieRanking = 'ルーキーランキング';
pixiv.text.daily_r18Ranking = 'R-18 デイリーランキング';
pixiv.text.r18gRanking = 'R-18G ランキング';
pixiv.text.maleRanking = '男子に人気ランキング';
pixiv.text.femaleRanking = '女子に人気ランキング';
```