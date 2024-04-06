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