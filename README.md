# pixiv-crawler

#### 概要

|プロジェクト名|機能|言語|
|---|---|---|
|pixiv-crawler|クローラー|Ruby|
|ImageLabelingGUI|画像ビューアー|C#|
|ImageManeger|画像管理|C++|
||機械学習|Python|


#### 保存するindexファイルの構造

* indexファイルは名前をつけるようにする。
- 例：index_today_2015-07-24.txt
- 例：index_maleRanking_2015-07-24.txt

```
id, image_id, user_id, date, for_men_labal, for_woman_labal, [tag1, tag2, ...]

```

id ...

image_id ...

user_id ...

date ... 

for_men_labal ...

for_woman_labal ...

tags ... 


#### 追加したい機能

##### 重大

* 大きい画像を取得できるように変更

* 画像管理クラス（重複画像のチェック等）
- C++かPythonでC#,Pythonの学習に使えるもの

* ランキングページの下までを自動で読み込む

##### 適宜 
* 下のいろんなランキングページのクローリングに対応

* 定期的に実行されるスクリプト

* １つの画像idに複数画像ある場合
- id_p0.jpgのような感じ

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