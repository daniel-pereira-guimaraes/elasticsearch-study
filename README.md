# Elasticsearch Study

## Preparing the study environment
We will study **Elasticsearch** and **Logstash**. So we need to install these tools.

### Installing Elasticsearch on Windows, using the zip package
+ Download the [Elasticsearch zip package](https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.13.4-windows-x86_64.zip) for Windows.
+ Extract the contents of the zip file to a directory (for example: C:\elasticsearch).
+ Open CMD or PowerShell, run the following command and wait:
```
C:\elasticsearch\bin\elasticsearch.bat
```
See also: [Checking Elasticsearch status](#checking-elasticsearch-status)

  
### Running Elasticsearch with Docker
Before proceeding, make sure you have **Docker** installed and running on your system.
More information at: [https://www.docker.com/get-started/](https://www.docker.com/get-started/)

#### Basic configuration
```
docker run -d -p 9200:9200 --name my_container elasticsearch:8.13.4
```
Where:
+ **9200**: Elasticsearch TCP/IP port.
+ **my_container**: Arbitrary name for the container.
+ **elasticsearch:8.13.4**: Docker image name and version for Elasticsearch.

#### With custom network
```
docker network create my_network
docker run -d -p 9200:9200 --name my_container --net my_network elasticsearch:8.13.4
```
Where **my_network** is a arbitrary name for Docker network.

#### With basic authentication enabled
```
docker run -d \
  -e discovery.type=single-node \
  -e xpack.security.enabled=true \
  -e ELASTIC_PASSWORD=my_password \
  -p 9200:9200 \
  --name my_container \
  elasticsearch:8.13.4
```
Where **my_password** is the password that should be provided for each access to Elasticsearch, as shown in the following example:
```
curl -u elastic:my_password http://localhost:9200?pretty
```

#### With custom network and basic authentication enabled
```
docker network create my_network

docker run -d \
  -e discovery.type=single-node \
  -e xpack.security.enabled=true \
  -e ELASTIC_PASSWORD=my_password \
  -p 9200:9200 \
  --name my_container \
  --net my_network \
  elasticsearch:8.13.4
```

### Checking Elasticsearch status
In the terminal (CMD or PowerShell on Windows), execute this command:
```
curl http://localhost:9200?pretty
```
But if basic authentication is enabled in Elasticsearch, the command should include the credentials, such as:
```
curl -u elastic:my_password http://localhost:9200?pretty
```
Example of the expected output:
```
{
  "name" : "115dcea1258b",
  "cluster_name" : "docker-cluster",
  "cluster_uuid" : "PJB8bJTcQouZybMFHH2-xg",
  "version" : {
    "number" : "8.13.0",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "09df99393193b2c53d92899662a8b8b3c55b45cd",
    "build_date" : "2024-03-22T03:35:46.757803203Z",
    "build_snapshot" : false,
    "lucene_version" : "9.10.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
```

### Installing Logstash on Windows, using zip package
+ Download the [Logstash zip package](https://artifacts.elastic.co/downloads/logstash/logstash-8.13.4-windows-x86_64.zip) for Windows.
+ Extract the contents of the zip file to a directory (for example: C:\logstash).

See also: [Import countries data from CSV file, using Logstash](#import-countries-data-from-csv-file-using-logstash)

## Importing data

### Import movies data from JSON file
#### Resource:
+ [movies.json](https://github.com/daniel-pereira-guimaraes/elasticsearch-study/blob/main/movies.json)
#### Command line:
```
curl -s -H "Content-Type: application/json" -XPUT localhost:9200/_bulk?pretty --data-binary @movies.json
```

### Create series index and import data
#### Create series index (master/detail)
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
#### Import series from JSON file
##### Resource:
+ [series.json](https://github.com/daniel-pereira-guimaraes/elasticsearch-study/blob/main/series.json)
##### Command line:
```
curl -s -H "Content-Type: application/json" -XPUT localhost:9200/_bulk?pretty --data-binary @series.json
```

### Create product index and import data
#### Create products index
```
curl -H "Content-Type: application/json" -XPUT "http://localhost:9200/products" -d '
{
  "mappings": {
    "properties": {
      "id": { "type": "integer" },
      "name": { 
        "type": "text",
        "fields": {
          "raw": {
            "type": "keyword"
          }
        }
      },
      "group": { "type": "keyword" },
      "stock": { "type": "integer" },
      "price": { "type": "float" }
    }
  }
}'
```
#### Import product data from JSON file
##### Resource:
+ [products.json](https://github.com/daniel-pereira-guimaraes/elasticsearch-study/blob/main/products.json)
##### Command line:
```
curl -H "Content-Type: application/json" -XPOST "http://localhost:9200/products/_bulk?pretty" --data-binary "@products.json"
```

### Import countries data from CSV file, using Logstash
#### Resources:
+ [countries.csv](https://github.com/daniel-pereira-guimaraes/elasticsearch-study/blob/main/countries.csv)
+ [csv-countries.conf](https://github.com/daniel-pereira-guimaraes/elasticsearch-study/blob/main/csv-countries.conf)
#### Command line:
```
c:\logstash\bin\logstash -f C:\data\csv-countries.conf
```

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

### Query three products with the highest prices
```
curl -H 'Content-Type: application/json' -XGET "localhost:9200/products/_search?pretty" -d '
{
  "query": {
    "match_all": {}
  },
  "sort": [
    {
      "price": {
        "order": "desc"
      }
    }
  ],
  "size": 3
}'
```

### Query products by name and order by name.raw
```
curl -H 'Content-Type: application/json' -XGET "localhost:9200/products/_search?pretty" -d '
{
  "query": {
    "match": {
      "name" : "PVC"
    }
  },
  "sort": [
    { "name.raw": "asc" }
  ]
}'
```
#### Returning only some attributes
```
curl -s -H 'Content-Type: application/json' -XGET "localhost:9200/products/_search?pretty&filter_path=hits.hits._source" -d '
{
  "query": {
    "match": {
      "name" : "PVC"
    }
  },
  "sort": [
    { "name.raw": "asc" }
  ],
  "_source": ["id", "name", "price"]
}'
```

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

### Quantity in stock per group
```
curl -H 'Content-Type: application/json' -XPOST 'http://localhost:9200/products/_search?pretty' -d '{
  "size": 0,
  "aggs": {
    "group_aggs": {
      "terms": {
        "field": "group"
      },
      "aggs": {
        "total_stock": {
          "sum": {
            "field": "stock"
          }
        }
      }
    }
  }
}'
```

### Financial value of stock by group

```
curl -H 'Content-Type: application/json' -XGET "localhost:9200/products/_search?pretty" -d '
{
  "size": 0,
  "aggs": {
    "by_group": {
      "terms": {
        "field": "group"
      },
      "aggs": {
        "total": {
          "sum": {
            "script": {
              "source": "doc[\"stock\"].value * doc[\"price\"].value"
            }
          }
        }
      }
    }
  }
}'
```

### Min, max and avg price by group

```
curl -H 'Content-Type: application/json' -XPOST 'http://localhost:9200/products/_search?pretty' -d '{
  "size": 0,
  "aggs": {
    "group_aggs": {
      "terms": {
        "field": "group"
      },
      "aggs": {
        "min_price": {
          "min": {
            "field": "price"
          }
        },
        "max_price": {
          "max": {
            "field": "price"
          }
        },
        "avg_price": {
          "avg": {
            "field": "price"
          }
        }
      }
    }
  }
}'
```

## Calculated field

Query products with these fields:
+ id
+ name
+ stock
+ price
+ total (stock * price)

```
curl -H 'Content-Type: application/json' -XGET "localhost:9200/products/_search?pretty" -d '
{
  "query": {
    "match_all": {}
  },
  "script_fields": {
    "total": {
      "script": {
        "source": "doc[\"stock\"].value * doc[\"price\"].value"
      }
    }
  },
  "_source": ["id", "name", "stock", "price"],
  "size": 10
}'
```
