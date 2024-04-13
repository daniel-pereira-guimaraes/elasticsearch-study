# Elasticsearch Study

## List all indices
`curl -X GET http://localhost:9200/_cat/indices?v`

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

## Insert a movie
```
curl -s -H "Content-Type: application/json" -XPOST localhost:9200/movies/_doc/109487 -d '
{
  "genre":["IMAX","Sci-Fi"],
  "title":"Interestellar",
  "year":2014
}'
```

## Get all movies
`curl -s -XGET localhost:9200/movies/_search?pretty`

## Get a movie
`curl -s -XGET localhost:9200/movies/_doc/109487?pretty`

## Update a movie
```
curl -s -H "Content-Type: application/json" -XPOST localhost:9200/movies/_doc/109487/_update -d '
{
  "doc": {
    "title":"Interestellar UPDATED"
  }
}'
```

## Delete a movie
`curl -s -XDELETE localhost:9200/movies/_doc/109487?pretty`

## Import movies from json file
`curl -s -H "Content-Type: application/json" -XPUT localhost:9200/_bulk?pretty --data-binary @movies.json`


## Conditional update movie
```
curl -s -H "Content-Type: application/json" -XPUT "localhost:9200/movies/_doc/109487?if_seq_no=10&if_primary_term=1" -d '
{
  "genres":["IMAX","Sci-Fi"],
  "title":"Interestellar 2",
  "year":2014
}'
```

## Update movie, retry on conflict
```
curl -s -H "Content-Type: application/json" -XPOST localhost:9200/movies/_doc/109487/_update?retry_on_conflict=5 -d '
{
  "doc":{
    "title":"Interestellar 3"  
  }
}'
```

## Create series index (master/detail)
```
curl -s -H "Content-Type: application/json" -XPUT localhost:9200/series -d '
{
  "mappings": {
    "properties": {
      "film_to_franchise": {
        "type":"join",
        "relations":{
          "franchise":"film"
        }
      }
    }
  }
}'
```

## Import series from json file (master/detail)
```
curl -s -H "Content-Type: application/json" -XPUT localhost:9200/_bulk?pretty --data-binary @series.json
```

## Get all films (details) from a serie (master)
```
curl -s -H "Content-Type: application/json" -XGET localhost:9200/series/_search?pretty -d '
{
  "query":{
    "has_parent":{
      "parent_type":"franchise",
      "query":{
        "match":{
          "title":"Star Wars"
        }
      }
    }
  }
}'
```

## Get serie (master) from a film (detail)
```
curl -s -H "Content-Type: application/json" -XGET localhost:9200/series/_search?pretty -d '
{
  "query":{
    "has_child":{
      "type":"film",
      "query":{
        "match":{
          "title":"The Force Awakens"
        }
      }
    }
  }
}'
```

## Find movies by title, using a simple query
`curl -s -XGET "http://127.0.0.1:9200/movies/_search?q=title:Wars&pretty"`

## Find movies where year > 2015, using a simple query
`curl -s -XGET "http://127.0.0.1:9200/movies/_search?q=year:>2015&pretty"`

## Find movies where year > 2010 AND year < 2016, using a simple query
`curl -s -XGET "http://127.0.0.1:9200/movies/_search?q=year:>2010+AND+year:<2016&pretty"`

## Find movies where year > 2010 AND title contains "force", using a simple query
`curl -s -XGET "http://127.0.0.1:9200/movies/_search?q=year:>2010+AND+title:force&pretty"`

## Find movies by title, using json query
```
curl -s -H "Content-Type:application/json" -XGET http://127.0.0.1:9200/movies/_search?pretty -d'
{
  "query":{
    "match":{
      "title":"force"
    }
  }
}'
```

## Find movies where year > 2015, using json query
```
curl -s -H "Content-Type:application/json" -XGET http://127.0.0.1:9200/movies/_search?pretty -d'
{
  "query":{
    "range":{
      "year":{
        "gt":2015
      }
    }
  }
}'
```

## Find movies where year > 2010 AND year < 2016, using json query
```
curl -s -H "Content-Type:application/json" -XGET http://127.0.0.1:9200/movies/_search?pretty -d'
{
  "query":{
    "range":{
      "year":{
        "gt":2010,
        "lt":2016
      }
    }
  }
}'
```

## Find movies where year > 2010 AND title contains "force", using json query
The word **must** is equivalent to the **AND** operator.
```
curl -s -H "Content-Type: application/json" -XGET "http://127.0.0.1:9200/movies/_search?pretty" -d '{
  "query": {
    "bool": {
      "must": [
        { "range": { "year": { "gt": 2010 } } },
        { "match": { "title": "force" } }
      ]
    }
  }
}'
```

## Find movies where year < 2010 OR year > 2015
The word **should** is equivalent to the **OR** operator.
```
curl -s -H "Content-Type: application/json" -XGET "http://127.0.0.1:9200/movies/_search?pretty" -d '{
  "query": {
    "bool": {
      "should": [
        { "range": { "year": { "lt": 2010 } } },
        { "range": { "year": { "gt": 2015 } } }
      ]
    }
  }
}'
```

## Find movies where title contains a phrase
```
curl -s -H "Content-Type:application/json" -XGET http://127.0.0.1:9200/movies/_search?pretty -d'
{
  "query":{
    "match_phrase":{
      "title":"star wars"
    }
  }
}'
```

## Find movies where title contains a few words
```
curl -s -H "Content-Type:application/json" -XGET http://127.0.0.1:9200/movies/_search?pretty -d'
{
  "query":{
    "match_phrase":{
      "title":{
        "query":"episode star",
        "slop":100
      }
    }
  }
}'
```

## Pagination
To use query result pagination, set the **from** and **size** parameters.

### Pagination using simple query
`curl -s -XGET "localhost:9200/movies/_search?pretty&from=0&size=2"`

### Pagination using json query
```
curl -s -H "Content-Type: application/json" -XGET "localhost:9200/movies/_search?pretty" -d '{
  "from": 0,
  "size": 2,
  "query": {
    "match_all": {}
  }
}'
```

## Ordering the results
To order query results, set the **sort** parameter.

### Order by year, ascending
#### Simple query:
```
curl -s -H "Content-Type: application/json" -XGET "localhost:9200/movies/_search?sort=year&pretty"
```

#### Json query:
```
curl -s -H "Content-Type: application/json" -XGET "localhost:9200/movies/_search?pretty" -d '{
  "sort": [
    { "year": "asc" }
  ]
}'
```

### Order by year, descending
```
curl -s -H "Content-Type: application/json" -XGET "localhost:9200/movies/_search?pretty" -d '{
  "sort": [
    { "year": "desc" }
  ]
}'
```

## Importing data from CSV file using Logstash
### Resources:
+ [countries.csv](https://github.com/daniel-pereira-guimaraes/elasticsearch-study/blob/main/countries.csv)
+ [csv-countries.conf](https://github.com/daniel-pereira-guimaraes/elasticsearch-study/blob/main/csv-countries.conf)
### Command line:
`c:\logstash\bin\logstash -f C:\data\csv-countries.conf`


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


## Aggregating data

### Count of countries by currency

```
curl -H 'Content-Type: application/json' -XPOST 'http://localhost:9200/countries/_search?pretty'  -d '
{
  "size": 0,
  "aggs": {
    "currency_aggs": {
      "terms": {
        "field": "currency"
      }
    }
  }
}'
```

### Preparing data for aggregation study

#### Create products index

```
curl -H "Content-Type: application/json" -XPUT "http://localhost:9200/products" -d '
{
  "mappings": {
    "properties": {
      "id": { "type": "integer" },
      "name": { "type": "text" },
      "group": { "type": "keyword" },
      "stock": { "type": "integer" },
      "price": { "type": "float" }
    }
  }
}'
```

#### Import product data from json file
```
curl -H "Content-Type: application/json" -XPOST "http://localhost:9200/products/_bulk?pretty" --data-binary "@products.json"
```

### Count of products by group
```
curl -H 'Content-Type: application/json' -XPOST 'http://localhost:9200/products/_search?pretty'  -d '
{
  "size": 0,
  "aggs": {
    "group_aggs": {
      "terms": {
        "field": "group"
      }
    }
  }
}'
```
