# DB パフォーマンス調査

Ruby on Rails + PostgreSQL で通常の INSERT, UPDATE と bulk_import どれが早いかを計測するためのテスト環境を Docker で構築。

## 環境構築

```
docker-compose build
docker-compose up
```
※初回はなぜかDBが起動後すぐにシャットダウンする？その場合はコンテナを落としてもう一度upする

Webサーバーに入る
```
docker-compose exec backend bash
```

入ったらDBの作成をして rails console 
```
rails db:create
rails db:migrate
rails db:migrate RAILS_ENV=test
rails console -e test
```

rails console 上で
```Ruby
require "./lib/benchmarks/bulk_import_benchmark"
benchmarker = BulkImportBenchmark.new(10000)
benchmarker.compare_bulk_insert
benchmarker.compare_bulk_update
```

# 実際に実行した結果

## INSERT

1万件のINSERTを実行。

- bulk insert by model
  - import メソッドへの引数を ActiveRecord モデルの配列で渡す
- bulk insert by hash ... 一番速い
  - import メソッドへの引数を ActiveRecord の attributes ハッシュの配列で渡す
- insert for each ... 一番遅い
  - 1件ずつ ActiveRecord の create メソッドで INSERT

```
1回目
                              user     system      total        real
prepare models           38.225186   0.079881  38.305067 ( 38.306216)
bulk insert by model      2.057343   0.012827   2.070170 (  5.750008)
bulk insert by hash       1.201335   0.002874   1.204209 (  5.052321)
insert for each           4.206996   0.293860   4.500856 (  9.970246)

2回目
                              user     system      total        real
prepare models           36.078738   0.094757  36.173495 ( 36.175990)
bulk insert by model      1.833065   0.017950   1.851015 (  5.609720)
bulk insert by hash       0.953733   0.018034   0.971767 (  4.994344)
insert for each           4.199318   0.309720   4.509038 (  9.833882)

3回目
                              user     system      total        real
prepare models           36.799376   0.094957  36.894333 ( 36.895273)
bulk insert by model      1.555066   0.017985   1.573051 (  4.340383)
bulk insert by hash       1.177433   0.002903   1.180336 (  4.589750)
insert for each           4.149652   0.312338   4.461990 (  9.118253)

4回目
                              user     system      total        real
prepare models           37.255918   0.081072  37.336990 ( 37.337862)
bulk insert by model      1.649046   0.015947   1.664993 (  4.627715)
bulk insert by hash       1.201767   0.006936   1.208703 (  4.001610)
insert for each           4.138445   0.305830   4.444275 (  8.834509)

5回目
                              user     system      total        real
prepare models           36.850520   0.087888  36.938408 ( 36.939514)
bulk insert by model      1.645766   0.024998   1.670764 (  5.112600)
bulk insert by hash       1.141774   0.009978   1.151752 (  5.517965)
insert for each           4.499263   0.365974   4.865237 ( 10.396293)
```

## UPDATE

1万件のUPDATEを実行。import 使用時も全件がUPDATE対象のレコード。

- update model for each ... 一番遅い
  - 1件ずつ ActiveRecord モデルの save メソッドで UPDATE
- update column for each
  - 1件ずつ ActiveRecord モデルの update_column メソッドで UPDATE
- bulk update by model
  - import メソッドへの引数を ActiveRecord モデルの配列で渡す
- bulk update by hash ... 一番速い
  - import メソッドへの引数を ActiveRecord の attributes ハッシュの配列で渡す

import が一番速いが、1件ずつの update_column に対してそれほどのアドバンテージはない

```
1回目
                              user     system      total        real
prepare models           32.459218   0.303186  32.762404 ( 32.928246)
bulk insert by hash       0.922509   0.027053   0.949562 (  3.377823)
update model for each     2.835480   0.272694   3.108174 (  3.929482)
update column for each    1.095478   0.180002   1.275480 (  2.012227)
bulk update by model      1.343564   0.025817   1.369381 (  1.957448)
bulk update by hash       0.625417   0.011995   0.637412 (  1.502920)

2回目
                              user     system      total        real
prepare models           35.522601   0.083915  35.606516 ( 35.607931)
bulk insert by hash       1.036655   0.014952   1.051607 (  4.449703)
update model for each     3.582750   0.277196   3.859946 (  7.062005)
update column for each    1.608753   0.245441   1.854194 (  4.925402)
bulk update by model      1.201485   0.028010   1.229495 (  4.919133)
bulk update by hash       0.796599   0.027103   0.823702 (  4.338946)

3回目
                              user     system      total        real
prepare models           35.373176   0.112402  35.485578 ( 35.488072)
bulk insert by hash       0.993322   0.014848   1.008170 (  4.358082)
update model for each     3.237029   0.270013   3.507042 (  7.471347)
update column for each    1.458552   0.217534   1.676086 (  4.858681)
bulk update by model      1.193038   0.010889   1.203927 (  4.250824)
bulk update by hash       0.801022   0.002843   0.803865 (  4.357635)

4回目
                              user     system      total        real
prepare models           36.445671   0.116768  36.562439 ( 36.563715)
bulk insert by hash       1.013055   0.029084   1.042139 (  4.744639)
update model for each     3.561351   0.278426   3.839777 (  7.728302)
update column for each    1.378905   0.250548   1.629453 (  5.119533)
bulk update by model      1.406051   0.010873   1.416924 (  5.467966)
bulk update by hash       0.909287   0.001884   0.911171 (  4.788958)

5回目
                              user     system      total        real
prepare models           38.462201   0.082589  38.544790 ( 38.545681)
bulk insert by hash       1.026528   0.013988   1.040516 (  4.761171)
update model for each     3.621548   0.259686   3.881234 (  7.167082)
update column for each    1.473418   0.260290   1.733708 (  4.719538)
bulk update by model      1.548145   0.012880   1.561025 (  4.315858)
bulk update by hash       0.947707   0.003895   0.951602 (  5.242057)
```
