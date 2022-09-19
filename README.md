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
