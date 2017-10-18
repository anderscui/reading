# Elasticsearch in Action

Tuning and scaling the setup required a deep understanding of ES and its features.

**Strong points** of ES:

* distributed model (scale out easily and efficiently)
* rich analytics functionality (on top of Lucene)

## Common refs

* Common options: https://www.elastic.co/guide/en/elasticsearch/reference/current/common-options.html

## UI tools

* [ES cerebro](https://github.com/lmenezes/cerebro)
* [ES head](https://github.com/mobz/elasticsearch-head)

# Ch01. Introducing ES

If you want to provide search for data:

* returning relevant search results
* returning statistics
* quickly

Data is represented in ES as documents (like MongoDB).

## 1.1 

Results need to come in quickly, and they need to be relevant, also includes detecting typos, providing suggestions, and breaking down results into categories.

### 1.1.1 quick searches

Inverted indexing.

### 1.1.3 search beyond exact matches

* Fuzzy
* Derivatives
* Statistics (aggregations)
* Suggestions (prefix, wildcard, regex)

## 1.2 Typical use cases

* Primary backend for your app (ES doesn't support transactions, 
* Adding ES to an existing system
* Backend of a ready-made solution built around it (Rsyslog, logstash, Apache Flume + ES + Kibana)

### 1.2.1

By default, ES gives your node a random node. Port 9300 is used by default for inter-node communication, called **transport**.

Each cluster has a master node.

# Ch02. Diving into the functionality

How data is organized in ES?

* Logical layout (index -> type -> documents)
* Physical layout (cluster -> node -> shards (lucene index)) 

## 2.1 Logical

Mapping types only divide documents logically. Physically, documents from the same index are written to disk regardless of the mapping type they belong to.

Each index has a string called *refresh_interval*.

There is not physical separation of documents that have **diff types**. In a shard, which is a Lucene index, the name of the type is a field, and all fields from all mappings come together as fields in the Lucene index.

To avoid unpredictable results, **two fields with the same name should have the same settings** (because they are not separated in the same index). 

Editing an existing doc implies deleting and indexing again.

A **term** is a word from the text and is the basic unit for searching.

### 2.1.1 Special fields

[meta-fields](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-fields.html)

[_all](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-all-field.html), we can create compound fields by `copy_to` (first_name and last_name -> full_name).

[_source](https://www.elastic.co/guide/en/elasticsearch/reference/current/mapping-source-field.html).

[multi-fields](https://www.elastic.co/guide/en/elasticsearch/reference/current/multi-fields.html)



## 2.2 Physical

A shard is a directory of files where Lucene stores the data for your index. A shard is also the small unit that ES moves from node to node.

Replicas can be added or removed at runtime-primaries can't.

### 2.2.1 Indexing

When you index a doc, it's first sent to one of the primary shards, which is chosen based on the doc's ID. (routing process)

(P80) Merging the is process of combining multiple small Lucene segments into a bigger segment. A segment is a chunk of the Lucene index (or a shard). Segments are never appended-only new ones are created as you index new docs. Lucene merges them from time to time.

### 2.2.2 Searching

Replicas are useful for both search performance and fault tolerance.

Searches are near-real time because they need to wait for a **refresh**, which by default happens every second.

Each search request has to be sent to all shards of an index.

If your result set grows, getting a page somewhere in the middle would be expensive.

Analyzed field or multivalued fields (e.g. tags) regularly result in multiple terms, so it's best to sort on not-analyzed or numeric fields.

### 2.2.3 Shards

Using shards enables you to scale horizaontally.

# Ch03. Indexing, updating and deleting data

You can config analysis to produce terms that are **synonyms** of your original terms. (how about the boosting factor?)

Setting `index` to `not_analyzed`: when you want exact matches, such as when you search for tags.

ES parses the date string and stores it as a number of type long in the Lucene index. ES parses ISO 8601 timestamps by default.

**TODO: Versioning in ES**

When deleting docs, ES only marks them to be deleted, so they don't show in searches, and gets them out of the index in an async manner.\

Removing types typically takes longer and uses more resources.


## 3.1 Scripts

A script is a piece of code in the JSON that you can send to ES, but it can also be an external script.

The default lan is **Painless**, and the Groovy is deprecated.

# Ch04. Searching DSL

[Query and filter context](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-filter-context.html)

Filters require less processing and are cacheable because they don't calc the score.

When you use the `range` query, think long and hard about whether a filter would be a better choice.

# Ch05. Analysis

ES goes through a number of steps for every analyzed field before the document is added to the index:

* Char filtering
* Breaking text into tokens
* Token filtering
* Token indexing

Queries such as `match` and `match_phrase` perform analysis before searching, and queries like `term` and `terms` do not.

[Term Vectors API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-termvectors.html)

# Ch06. Searching with relevancy

[fielddata/doc_values](https://www.elastic.co/guide/en/elasticsearch/reference/current/fielddata.html)

[Explain API](https://www.elastic.co/guide/en/elasticsearch/reference/current/search-explain.html)

**rescore**

**function_score**

**weight**

Scripts will be much slower than regular scoring because they must be executed dynamically for each doc that matches your query.

# Ch09. Scales out

[Nodes config](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html)

Alias

# Ch10. Cache











