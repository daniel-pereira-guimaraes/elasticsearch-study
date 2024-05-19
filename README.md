# Elasticsearch Study

## Table of Contents

+ [Preparing the study environment](#preparing-the-study-environment)
   + [Installing Elasticsearch on Windows, using the zip package](#installing-elasticsearch-on-windows-using-the-zip-package)
   + [Running Elasticsearch with Docker](#running-elasticsearch-with-docker)
      + [Basic configuration](#basic-configuration)
      + [With custom network](#with-custom-network)
      + [With basic authentication enabled](#with-basic-authentication-enabled)
      + [With custom network and basic authentication enabled](#with-custom-network-and-basic-authentication-enabled)
   + [Checking Elasticsearch status](#checking-elasticsearch-status)
+ [Installing Logstash on Windows, using zip package](#installing-logstash-on-windows-using-zip-package)
+ [Importing data](#importing-data)
   + [Import movies data from JSON file](#import-movies-data-from-json-file)
   + [Create series index and import data](#create-series-index-and-import-data)
   + [Create product index and import data](#create-product-index-and-import-data)
   + [Import countries data from CSV file, using Logstash](#import-countries-data-from-csv-file-using-logstash)
+ [Index operations](#index-operations)
   + [List all indices](#list-all-indices)
   + [Delete movies index](#delete-movies-index)
   + [Create movies index](#create-movies-index)
   + [Get movies mapping](#get-movies-mapping)
+ [Inserting, getting, updating and deleting documents](#inserting-getting-updating-and-deleting-documents)
   + [Insert a movie](#insert-a-movie)
   + [Get all movies](#get-all-movies)
   + [Get a movie](#get-a-movie)
   + [Update a movie](#update-a-movie)
   + [Conditional update movie](#conditional-update-movie)
   + [Update movie, retry on conflict](#update-movie-retry-on-conflict)
   + [Delete a movie](#delete-a-movie)
+ [Master/details queries](master-details-queries)
   + [Get all films (details) from a serie (master)](#get-all-films-details-from-a-serie-master)
   + [Get serie (master) from a film (detail)](#get-serie-master-from-a-film-detail)
+ [Finding data with simple query](#finding-data-with-simple-query)
   + [Find movies by title](#find-movies-by-title)
   + [Find movies where year > 2015](#find-movies-where-year--2015)
   + [Find movies where year > 2010 AND year < 2016](#find-movies-where-year--2010-and-year--2016)
   + [Find movies where year > 2010 AND title contains "force"](#find-movies-where-year--2010-and-title-contains-force)
+ [Finding data using JSON query](#finding-data-using-json-query)
   + [Find movies by title](#find-movies-by-title-1)
   + [Find movies where year > 2015](#find-movies-where-year--2015-1)
   + [Find movies where year > 2010 AND year < 2016](#find-movies-where-year--2010-and-year--2016-1)
   + [Find movies where year > 2010 AND title contains "force"](#find-movies-where-year--2010-and-title-contains-force-1)
   + [Find movies where year < 2010 OR year > 2015](#find-movies-where-year--2010-or-year--2015)
   + [Find movies where title contains a phrase](#find-movies-where-title-contains-a-phrase)
   + [Find movies where title contains a few words](#find-movies-where-title-contains-a-few-words)
+ [Pagination](#pagination)
  + [Pagination using simple query](#pagination-using-simple-query)
  + [Pagination using JSON query](#pagination-using-json-query)
+ [Ordering the results](#ordering-the-results)
  + [Order by year, ascending](#order-by-year-ascending)
  + [Order by year, descending](#order-by-year-descending)
  + [Query three products with the highest prices](#query-three-products-with-the-highest-prices)
  + [Query products by name and order by name.raw](#query-products-by-name-and-order-by-nameraw)
  + [Returning only some attributes](#returning-only-some-attributes)
+ [Changing the field type](#changing-the-field-type)
  + [Create a temporary index](#create-a-temporary-index)
  + [Copy data to temporary index](#copy-data-to-temporary-index)
  + [Delete old index](#delete-old-index)
  + [Recreate the old index](#recreate-the-old-index)
  + [Copy data to old recreated index](#copy-data-to-old-recreated-index)
  + [Delete temporary index](#delete-temporary-index)
+ [Aggregating data](#aggregating-data)
  + [Count of products by group](#count-of-products-by-group)
  + [Quantity in stock per group](#quantity-in-stock-per-group)
  + [Financial value of stock by group](#financial-value-of-stock-by-group)
  + [Min, max and avg price by group](#min-max-and-avg-price-by-group)
+ [Calculated field](#calculated-field)

+ [Users and permissions](#users-and-permissions)
  + [Creating a new index for access testing](#creating-a-new-index-for-access-testing)
  + [Insert some countries for testing](#insert-some-countries-for-testing)
  + [Create a new role for read-only access to the countries index](#create-a-new-role-for-read-only-access-to-the-countries-index)
  + [Create a new user with read-only access to the countries index](#create-a-new-user-with-read-only-access-to-the-countries-index)
  + [Get user data](#get-user-data)
  + [List all users](#list-all-users)
  + [Listing countries with new user credentials](#listing-countries-with-new-user-credentials)
  + [Trying insert a new country with new user credentials](#trying-insert-a-new-country-with-new-user-credentials)
  + [Deleting an user](#deleting-an-user)
  + [Deleting a role](#deleting-a-role)
  + [Resetting password via command line script](#resetting-password-via-command-line-script)
  + [More information about Elasticsearch security](#more-information-about-elasticsearch-security)

+ [More queries](#more-queries)
  + [Filtering results with filter_path parameter and _source](#filtering-results-with-filter_path-parameter-and-_source)
  + [Searching with SQL in Elasticsearch](#searching-with-sql-in-elasticsearch)
  + [Counting all countries](#counting-all-countries)
  + [Counting countries with USD currency](#counting-countries-with-usd-currency)

    
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
See also: [Installing Logstash on Windows, using zip package](#installing-logstash-on-windows-using-zip-package)

## Index operations

### List all indices
`curl -X GET http://localhost:9200/_cat/indices?v`

### Delete movies index
`curl -s -XDELETE localhost:9200/movies`

### Create movies index
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

### Get movies mapping
`curl -s -XGET localhost:9200/movies/_mapping`

## Inserting, getting, updating and deleting documents

### Insert a movie
```
curl -s -H "Content-Type: application/json" -XPOST localhost:9200/movies/_doc/109487 -d '
{
  "genre":["IMAX","Sci-Fi"],
  "title":"Interestellar",
  "year":2014
}'
```

### Get all movies
`curl -s -XGET localhost:9200/movies/_search?pretty`

### Get a movie
`curl -s -XGET localhost:9200/movies/_doc/109487?pretty`

### Update a movie
```
curl -s -H "Content-Type: application/json" -XPOST localhost:9200/movies/_doc/109487/_update -d '
{
  "doc": {
    "title":"Interestellar UPDATED"
  }
}'
```

### Conditional update movie
```
curl -s -H "Content-Type: application/json" -XPUT "localhost:9200/movies/_doc/109487?if_seq_no=10&if_primary_term=1" -d '
{
  "genres":["IMAX","Sci-Fi"],
  "title":"Interestellar 2",
  "year":2014
}'
```

### Update movie, retry on conflict
```
curl -s -H "Content-Type: application/json" -XPOST localhost:9200/movies/_doc/109487/_update?retry_on_conflict=5 -d '
{
  "doc":{
    "title":"Interestellar 3"  
  }
}'
```

### Delete a movie
`curl -s -XDELETE localhost:9200/movies/_doc/109487?pretty`

## Master/details queries

### Get all films (details) from a serie (master)
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

### Get serie (master) from a film (detail)
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

## Finding data with simple query

### Find movies by title
`curl -s -XGET "http://127.0.0.1:9200/movies/_search?q=title:Wars&pretty"`

### Find movies where year > 2015
`curl -s -XGET "http://127.0.0.1:9200/movies/_search?q=year:>2015&pretty"`

### Find movies where year > 2010 AND year < 2016
`curl -s -XGET "http://127.0.0.1:9200/movies/_search?q=year:>2010+AND+year:<2016&pretty"`

### Find movies where year > 2010 AND title contains "force"
`curl -s -XGET "http://127.0.0.1:9200/movies/_search?q=year:>2010+AND+title:force&pretty"`


## Finding data using JSON query

### Find movies by title
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

### Find movies where year > 2015
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

### Find movies where year > 2010 AND year < 2016
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

### Find movies where year > 2010 AND title contains "force"
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

### Find movies where year < 2010 OR year > 2015
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

### Find movies where title contains a phrase
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

### Find movies where title contains a few words
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

### Pagination using JSON query
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
#### JSON query:
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

## Users and permissions

The next topics demonstrate how to create, modify, and delete a user. 
A user will be created who can only read data from a specific index.


### Creating a new index for access testing
```
curl -s -u elastic:password \
     -H "Content-Type: application/json" \
     -X PUT "localhost:9200/countries" \
     -d '{
           "mappings": {
             "properties": {
               "iso_code": {
                 "type": "keyword"
               },
               "country_name": {
                 "type": "text"
               }
             }
           }
         }'
```
         
#### Expected output:
```
{"acknowledged":true,"shards_acknowledged":true,"index":"countries"}
```

### Insert some countries for testing
```
curl -s -u elastic:password \
     -H "Content-Type: application/json" \
     -X POST "localhost:9200/countries/_doc?pretty" \
     -d '{
           "iso_code": "BR",
           "country_name": "Brazil"
         }'

curl -s -u elastic:password \
     -H "Content-Type: application/json" \
     -X POST "localhost:9200/countries/_doc?pretty" \
     -d '{
           "iso_code": "US",
           "country_name": "United States"
         }'

```

### Create a new role for read-only access to the countries index
```
curl -s -u elastic:password \
     -H "Content-Type: application/json" \
     -X PUT "localhost:9200/_security/role/read_only_countries" \
     -d '{
           "indices": [
             {
               "names": ["countries"],
               "privileges": ["read"]
             }
           ]
         }'
```

#### Expected output:
```
{"role":{"created":true}}
```
 
### Create a new user with read-only access to the countries index:
```
curl -s -u elastic:password \
  -H "Content-Type: application/json" \
  -X POST "localhost:9200/_security/user/daniel" \
  -d '
    {
      "password": "myPassword",
      "roles": ["read_only_countries"]
    }'
```
    
#### Expected output:
```
{"created" : true}
```
  
**Important!** To update a user, replace the POST method with PUT.
  
### Get user data
```
curl -s -u elastic:password -X GET "localhost:9200/_security/user/daniel?pretty"
```

#### Expected output:
```
{
  "daniel" : {
    "username" : "daniel",
    "roles" : [
      "read_only_countries"
    ],
    ...
  }
}
```

### List all users
```
curl -s -u elastic:password -X GET "localhost:9200/_security/user?pretty"
```

#### Expected output:
JSON containing data of all users.

### Listing countries with new user credentials
```
curl -s -u daniel:myPassword -X GET localhost:9200/countries/_search?pretty
```

#### Expected output:
JSON containing countries!

### Trying insert a new country with new user credentials:
```
curl -s -u daniel:MyPassword \
     -H "Content-Type: application/json" \
     -X POST "localhost:9200/countries/_doc?pretty" \
     -d '{
           "iso_code": "PT",
           "country_name": "Portugal"
         }'
```
         
#### Expected output:
JSON with error information (security_exception)

### Deleting an user
```
curl -s -u elastic:password -X DELETE "localhost:9200/_security/user/daniel"
```

#### Expected output:
```
{"found":true}
```

### Deleting a role
```
curl -s -u elastic:password -X DELETE "localhost:9200/_security/role/read_only_countries"
```

#### Expected output:
```
{"found":true}
```

### Resetting password via command line script
+ Access the **bin** subdirectory of your elasticsearch installation.
+ Run **elasticsearch-reset-password** script:
  + `elasticsearch-reset-password <options> --username <username>`
+ Examples:
  + Reset the password for the **elastic** user to an automatically generated password:
    + `elasticsearch-reset-password -a --username elastic`
  + Reset the password for the **elastic** user to a specified password:
    + `elasticsearch-reset-password -i --username elastic`

### More information about Elasticsearch security
For more information about Elasticsearch security, 
[clique here!](https://www.elastic.co/guide/en/elasticsearch/reference/current/secure-cluster.html)

## More queries

### Filtering results with filter_path parameter and _source

#### Returns only _id and some _source fields
```
curl -X GET "localhost:9200/countries/_search?pretty&filter_path=hits.hits._id,hits.hits._source" \
     -H "Content-Type:application/json" \
     -d '{
        "_source": ["name", "currency"]
      }'
```

### Searching with SQL in Elasticsearch

```
curl -s \
     -X POST "localhost:9200/_sql?format=csv" \
     -H "Content-Type:application/json" \
     -d '{"query":"SELECT iso2, name, longitude FROM countries ORDER BY latitude LIMIT 5"}'
```

#### Expected output:
```
iso2,name,longitude
AQ,Antarctica,4.48
GS,South Georgia,-37.0
BV,Bouvet Island,3.4
HM,Heard Island and McDonald Islands,72.51666666
FK,Falkland Islands,-59.0
```

### Counting all countries
```
curl -s -X GET "localhost:9200/countries/_count"
```
#### Expected result:
```
{"count":250,"_shards":{"total":1,"successful":1,"skipped":0,"failed":0}}
```

### Counting countries with USD currency
```
curl -s -X POST "localhost:9200/countries/_count" \
     -H "Content-Type: application/json" \
     -d '{
        "query": {
            "term": {
                "currency": "USD"
            }
        }
     }'
```
#### Expected result:
```
{"count":17,"_shards":{"total":1,"successful":1,"skipped":0,"failed":0}}
```
