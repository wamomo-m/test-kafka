# test-kafka

## 登場人物

- Kafka ブローカー

- ワーカーノード (Kafka コネクターインスタンスをホストする)
  - debezium/connector

- Kafka コネクターインスタンス (Source/Sink)
  - ワーカーノードに登録するやつ

- zookeeper
  - Kafka ブローカーのクラスターをマネジメントする
  - Kafka ワーカークラスターのマネジメントはしなさそう (なくても動く && ワーカーの設定値に zookeeper がない)

## Kafka


## Debezium

データベースをイベントストリームに変えるためのプラットフォーム  
CDC を実現する

- https://access.redhat.com/documentation/ja-jp/red_hat_integration/2021.q3/html-single/debezium_user_guide/index

- https://access.redhat.com/documentation/ja-jp/red_hat_integration/2021.q3/html-single/debezium_user_guide/index#descriptions-of-debezium-mysql-connector-configuration-properties

### Outbox Event Router

- https://debezium.io/documentation/reference/stable/transformations/outbox-event-router.html

### Kafka Connector REST APIs

```sh
curl -i -X POST http://localhost:8083/connectors -H "Accept:application/json" -H "Content-Type:application/json" -d @connector/mysql0_sample_outbox.json
```

```sh
curl -s http://localhost:8083/connectors/mysql0-sample.outbox/status | jq .
```

```sh
curl -s http://localhost:8083/connectors/mysql0-sample.outbox/config | jq .
```

```sh
curl -s http://localhost:8083/connectors?expand=info | jq .
```

```sh
curl -s http://localhost:8083/connectors?expand=status | jq .
```

```sh
curl -i -X DELETE http://localhost:8083/connectors/mysql0-sample.outbox
```

```sh
curl -i -X POST http://localhost:8083/connectors/mysql0-sample.outbox/restart
```

```sh
curl -i -X POST http://localhost:8085/connectors/mysql2-sample.outbox/tasks/0/restart
```

```sh
curl -i -X PUT http://localhost:8083/connectors/mysql0-sample.outbox/config -H "Accept:application/json" -H "Content-Type:application/json" -d @connector/update.json
```

- わかりやすい
  - https://docs.confluent.io/platform/current/connect/references/restapi.html#tasks


### Kafka ワーカークラスター


### 問題

一部ワーカーの POST リクエストのレスポンスが 500 (Timeout) になる

下記と同じとみられる現象が起こる  
(同時に起動したことが要因？で、成功したこともあった)

- https://stackoverflow.com/questions/41253780/second-and-third-distributed-kafka-connector-workers-failing-to-work-correctly

### 解決方法1

ワーカークラスター同士が通信する必要があるので、同一ネットワークに所属させる

- https://rmoff.net/2019/11/22/common-mistakes-made-when-configuring-multiple-kafka-connect-workers/

- confluent doc https://docs.confluent.io/platform/current/connect/concepts.html#distributed-workers

- https://docs.confluent.io/ja-jp/platform/current/connect/concepts.html#distributed-workers

docker network の IP アドレスで通信しようとしてそうなので (worker_id が [IP Address]:[port])
`CONNECT_REST_ADVERTISED_HOST_NAME` の設定を特別指定する必要はなさそう

### 解決方法2

Kafka の内部用トピックとイベント用トピックの Kafka を分ける

- https://docs.confluent.io/ja-jp/platform/7.1/connect/references/allconfigs.html#override-the-worker-configuration

- https://docs.confluent.io/ja-jp/platform/current/multi-dc-deployments/replicator/replicator-run.html#running-crep-on-the-source-cluster

### 解決方法3

Kafka ワーカークラスターを別にする

`GROUP_ID` (String) をそれぞれ一意にする

内部トピックもそれぞれ別にする必要がある

- https://docs.confluent.io/ja-jp/platform/7.1/connect/userguide.html#kconnect-internal-topics



## Kafka 内部トピック

- https://docs.confluent.io/ja-jp/platform/7.1/connect/userguide.html#kconnect-internal-topics


### 問題

connecter, task が死んだ後の自動復帰方法がない

再現: 
  コネクターと監視対象 (DB) が接続後、監視対象サーバを落とす -> 再起動

https://groups.google.com/g/debezium/c/ajYvC97JAOc/m/zeIxcFdpBgAJ
https://issues.apache.org/jira/browse/KAFKA-5352
