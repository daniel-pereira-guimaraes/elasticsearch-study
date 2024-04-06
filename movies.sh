#!/bin/bash

# Delete movies index
curl -s -XDELETE localhost:9200/movies

echo -e "\n---\n"

# Create movies index
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

# Get movies mapping
curl -s -XGET localhost:9200/movies/_mapping

# Insert a movie
curl -s -H "Content-Type: application/json" -XPOST localhost:9200/movies/_doc/109487 -d '
{
  "genre":["IMAX","Sci-Fi"],
  "title":"Interestellar",
  "year":2014
}'

# Get all movies
curl -s -XGET localhost:9200/movies/_search?pretty

# Get a movie
curl -s -XGET localhost:9200/movies/_doc/109487?pretty


# Update a movie
curl -s -H "Content-Type: application/json" -XPOST localhost:9200/movies/_doc/109487/_update -d '
{
  "doc": {
    "title":"Interestellar UPDATED"
  }
}'

# Delete a movie
curl -s -XDELETE localhost:9200/movies/_doc/109487?pretty

# Download movies.json
curl -o movies.json http://media.sundog-soft.com/es7/movies.json

# Import movies from json file
curl -s -H "Content-Type: application/json" -XPUT localhost:9200/_bulk?pretty --data-binary @movies.json

# Conditional update movie
curl -s -H "Content-Type: application/json" -XPUT "localhost:9200/movies/_doc/109487?if_seq_no=10&if_primary_term=1" -d '
{
  "genres":["IMAX","Sci-Fi"],
  "title":"Interestellar 2",
  "year":2014
}'