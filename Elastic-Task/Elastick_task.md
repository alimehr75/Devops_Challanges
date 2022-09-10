# The Task 
```text
1 - Install and configure Elasticsearch

2 - Install and configure Kibana

3 - Create an index and give it whatever name you would like.

4 - Create several documents with different salaries for 3 months per name including the below field+mapping info:

- name: string

- surname: string

- salary: float

- job_title: string

- age: integer

5 - Run a query against job_titles that could return the whole docs even with partial-word search

6 - Create a visualization in Kibana that demonstrates the sum of the salaries of an employee for that very 3 months.


[Further Step - Optional]

7 - Define an index pattern with timestamp for the documents.

```

## 3rd & 4rth Step 
```
PUT salary-for-3-months
{
  "mappings": {
    "properties": {
      "date":{
        "type": "date"
      },
      "name": {
        "type": "text"
      },
      "surname":{
        "type": "text"
      },
      "salary":{
        "type": "float"
      },
      "job_title":{
        "type": "text"
      },
      "age": {
        "type": "integer"
      }
    }
  }
}
```

## Step 7
> This ingest is for timestamp 
```
PUT _ingest/pipeline/timestamp
{
  "description": "Adds timestamp to documents",
  "processors": [
    {
      "set": {
        "field": "_source.timestamp",
        "value": "{{_ingest.timestamp}}"
      }
    }
  ]
}
```

## 4th Step Again
```
# -------------- Gholi --------------------------------

POST salary-for-3-months/_create/1?pipeline=timestamp
{
  "name":"Gholi",
  "date":"2015-01-31",
  "surname":"Gholizadeh",
  "salary":25000000,
  "job_title":"Developer",
  "age":"35"
  
}

POST salary-for-3-months/_create/2?pipeline=timestamp
{
  "name":"Gholi",
  "date":"2015-02-28",
  "surname":"Gholizadeh",
  "salary":21000000,
  "job_title":"Developer",
  "age":"35"
  
}

POST salary-for-3-months/_create/3?pipeline=timestamp
{
  "name":"Gholi",
  "date":"2015-03-31",
  "surname":"Gholizadeh",
  "salary":23000000,
  "job_title":"Developer",
  "age":"35"
  
}

# -------------- Gholam --------------------------------

POST salary-for-3-months/_create/4?pipeline=timestamp
{
  "name":"Gholam",
  "date":"2015-01-31",
  "surname":"Gholami",
  "salary":9000000,
  "job_title":"IT Specialist",
  "age":"35"
  
}

POST salary-for-3-months/_create/5?pipeline=timestamp
{
  "name":"Gholam",
  "date":"2015-02-28",
  "surname":"Gholami",
  "salary":10000000,
  "job_title":"IT Specialist",
  "age":"35"
  
}


POST salary-for-3-months/_create/6?pipeline=timestamp
{
  "name":"Gholam",
  "date":"2015-03-31",
  "surname":"Gholami",
  "salary":80000000,
  "job_title":"IT Specialist",
  "age":"35"
  
}

# --------------- Yadi ----------------------------------

POST salary-for-3-months/_create/7?pipeline=timestamp
{
  "name":"Yadollah",
  "date":"2015-01-31",
  "surname":"YadiPoor",
  "salary":170000000,
  "job_title":"Bank Teller",
  "age":"26"
  
}

POST salary-for-3-months/_create/8?pipeline=timestamp
{
  "name":"Yadollah",
  "date":"2015-02-28",
  "surname":"YadiPoor",
  "salary":150000000,
  "job_title":"Bank Teller",
  "age":"26"
  
}

POST salary-for-3-months/_create/9?pipeline=timestamp
{
  "name":"Yadollah",
  "date":"2015-03-31",
  "surname":"YadiPoor",
  "salary":190000000,
  "job_title":"Bank Teller",
  "age":"26"
  
}


```
## What do we have far now  ? 
### Search in whole index (Query)
```
GET salary-for-3-months/_search
{
  "query": {
    "match_all": {}
  }
}

```
### Response 
```
{
  "took": 207,
  "timed_out": false,
  "_shards": {
    "total": 1,
    "successful": 1,
    "skipped": 0,
    "failed": 0
  },
  "hits": {
    "total": {
      "value": 9,
      "relation": "eq"
    },
    "max_score": 1,
    "hits": [
      {
        "_index": "salary-for-3-months",
        "_id": "1",
        "_score": 1,
        "_source": {
          "date": "2015-01-31",
          "surname": "Gholizadeh",
          "name": "Gholi",
          "salary": 25000000,
          "job_title": "Developer",
          "age": "35",
          "timestamp": "2022-09-10T13:34:50.570226535Z"
        }
      },
      {
        "_index": "salary-for-3-months",
        "_id": "2",
        "_score": 1,
        "_source": {
          "date": "2015-02-28",
          "surname": "Gholizadeh",
          "name": "Gholi",
          "salary": 21000000,
          "job_title": "Developer",
          "age": "35",
          "timestamp": "2022-09-10T13:36:53.592595690Z"
        }
      },
      {
        "_index": "salary-for-3-months",
        "_id": "3",
        "_score": 1,
        "_source": {
          "date": "2015-03-31",
          "surname": "Gholizadeh",
          "name": "Gholi",
          "salary": 23000000,
          "job_title": "Developer",
          "age": "35",
          "timestamp": "2022-09-10T13:40:49.579551913Z"
        }
      },
      {
        "_index": "salary-for-3-months",
        "_id": "4",
        "_score": 1,
        "_source": {
          "date": "2015-01-31",
          "surname": "Gholami",
          "name": "Gholam",
          "salary": 9000000,
          "job_title": "IT Specialist",
          "age": "35",
          "timestamp": "2022-09-10T13:43:47.193253627Z"
        }
      },
      {
        "_index": "salary-for-3-months",
        "_id": "5",
        "_score": 1,
        "_source": {
          "date": "2015-02-28",
          "surname": "Gholami",
          "name": "Gholam",
          "salary": 10000000,
          "job_title": "IT Specialist",
          "age": "35",
          "timestamp": "2022-09-10T13:44:31.892183114Z"
        }
      },
      {
        "_index": "salary-for-3-months",
        "_id": "6",
        "_score": 1,
        "_source": {
          "date": "2015-03-31",
          "surname": "Gholami",
          "name": "Gholam",
          "salary": 80000000,
          "job_title": "IT Specialist",
          "age": "35",
          "timestamp": "2022-09-10T13:45:42.069181999Z"
        }
      },
      {
        "_index": "salary-for-3-months",
        "_id": "7",
        "_score": 1,
        "_source": {
          "date": "2015-01-31",
          "surname": "YadiPoor",
          "name": "Yadollah",
          "salary": 170000000,
          "job_title": "Bank Teller",
          "age": "26",
          "timestamp": "2022-09-10T13:57:17.114682662Z"
        }
      },
      {
        "_index": "salary-for-3-months",
        "_id": "8",
        "_score": 1,
        "_source": {
          "date": "2015-02-28",
          "surname": "YadiPoor",
          "name": "Yadollah",
          "salary": 150000000,
          "job_title": "Bank Teller",
          "age": "26",
          "timestamp": "2022-09-10T13:57:39.524456791Z"
        }
      },
      {
        "_index": "salary-for-3-months",
        "_id": "9",
        "_score": 1,
        "_source": {
          "date": "2015-03-31",
          "surname": "YadiPoor",
          "name": "Yadollah",
          "salary": 190000000,
          "job_title": "Bank Teller",
          "age": "26",
          "timestamp": "2022-09-10T13:58:11.435188580Z"
        }
      }
    ]
  }
}
```
## Step 5
### Query by job_title
```
GET salary-for-3-months/_search 
{
  "query": {
    "match_phrase_prefix": {
      "job_title": "Dev"
    }
  }, 
  "aggs": {
    "by_category": {
      "terms": {
        "field": "job_title.keyword",
        "size": 100
      }
    }
  }
}

```

### Response
```
{
  "took": 1,
  "timed_out": false,
  "_shards": {
    "total": 1,
    "successful": 1,
    "skipped": 0,
    "failed": 0
  },
  "hits": {
    "total": {
      "value": 3,
      "relation": "eq"
    },
    "max_score": 1.255222,
    "hits": [
      {
        "_index": "salary-for-3-months",
        "_id": "1",
        "_score": 1.255222,
        "_source": {
          "date": "2015-01-31",
          "surname": "Gholizadeh",
          "name": "Gholi",
          "salary": 25000000,
          "job_title": "Developer",
          "age": "35",
          "timestamp": "2022-09-10T14:41:59.102693355Z"
        }
      },
      {
        "_index": "salary-for-3-months",
        "_id": "2",
        "_score": 1.255222,
        "_source": {
          "date": "2015-02-28",
          "surname": "Gholizadeh",
          "name": "Gholi",
          "salary": 21000000,
          "job_title": "Developer",
          "age": "35",
          "timestamp": "2022-09-10T14:42:01.595810998Z"
        }
      },
      {
        "_index": "salary-for-3-months",
        "_id": "3",
        "_score": 1.255222,
        "_source": {
          "date": "2015-03-31",
          "surname": "Gholizadeh",
          "name": "Gholi",
          "salary": 23000000,
          "job_title": "Developer",
          "age": "35",
          "timestamp": "2022-09-10T14:42:03.764740536Z"
        }
      }
    ]
  },
  "aggregations": {
    "by_category": {
      "doc_count_error_upper_bound": 0,
      "sum_other_doc_count": 0,
      "buckets": [
        {
          "key": "Developer",
          "doc_count": 3
        }
      ]
    }
  }
}

```


