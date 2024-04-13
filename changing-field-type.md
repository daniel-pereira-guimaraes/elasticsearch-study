## Changing the field type

### Create a temporary index

```
curl -H 'Content-Type: application/json' -XPUT "http://localhost:9200/temp-index?pretty"  -d '
{
  "mappings": {
    "properties": {
      "id": {"type": "integer"},
      "code": {"type": "keyword"},
      "name": {"type": "text"},
      "currency": {"type": "keyword"},
      "latitude": {"type": "float"},
      "longitude": {"type": "float"}
    }
  }
}'
```

### Copy data to temporary index

```
curl -H 'Content-Type: application/json' -XPOST "http://localhost:9200/_reindex?pretty" -d '
{
  "source": {
    "index": "countries"
  },
  "dest": {
    "index": "temp-index"
  }
}'
```

### Delete old index

```
curl -XDELETE http://localhost:9200/countries
```

### Recreate the old index

```
curl -H 'Content-Type: application/json' -XPUT "http://localhost:9200/countries?pretty"  -d '
{
  "mappings": {
    "properties": {
      "id": {"type": "integer"},
      "code": {"type": "keyword"},
      "name": {"type": "text"},
      "currency": {"type": "keyword"},
      "latitude": {"type": "float"},
      "longitude": {"type": "float"}
    }
  }
}'
```

### Copy data to old recreated index

```
curl -H 'Content-Type: application/json' -XPOST "http://localhost:9200/_reindex?pretty" -d '
{
  "source": {
    "index": "temp-index"
  },
  "dest": {
    "index": "countries"
  }
}'
```

### Delete temporary index

```
curl -XDELETE http://localhost:9200/temp-index
```
