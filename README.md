# test-kafka

## 登場人物

- Kafka ブローカー

- ワーカーノード (Kafka コネクターインスタンスをホストする)
  - debezium/connector

- Kafka コネクターインスタンス (Source/Sink)
  - ワーカーノードに登録するやつ

- zookeeper
  - Kafka ブローカーのクラスターをマネジメントする

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
curl -i -X PUT http://localhost:8083/connectors/mysql0-sample.outbox/config -H "Accept:application/json" -H "Content-Type:application/json" -d @connector/update.json
```

- わかりやすい
  - https://docs.confluent.io/platform/current/connect/references/restapi.html#tasks
