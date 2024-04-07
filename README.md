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

# Find movies where title contains a phrase
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

# Find movies where title contains a few words
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
