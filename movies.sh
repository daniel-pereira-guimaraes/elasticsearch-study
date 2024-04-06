#!/bin/bash

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

