#!/bin/bash

# Delete movies index
curl -XDELETE localhost:9200/movies

echo -e "\n---\n"

# Create movies index
curl -H "Content-Type: application/json" -XPUT localhost:9200/movies -d '
{
  "mappings": {
	"properties": {
	  "year": {
		"type": "date"
	  }
	}
  }
}'

