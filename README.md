# Elasticsearch Study

## Delete movies index
`curl -s -XDELETE localhost:9200/movies`

## Create movies index
```
curl -s -H "Content-Type: application/json" -XPUT localhost:9200/movies -d '
{
  "mappings": {
    "properties": {
      "year": {
        "type": "date"
      }
    }
  }
}'
```

## Get movies mapping
`curl -s -XGET localhost:9200/movies/_mapping`
