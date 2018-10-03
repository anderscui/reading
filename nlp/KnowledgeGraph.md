# Mining Knowledge Graphs from Text

Original：[Mining Knowledge Graphs from Text](https://kgtutorial.github.io/)

# Part 1 - Knowledge Graph Primer

## KG Primer

什么是知识图谱？

* 以图（graph）的形式构建的知识（knowledge）结构
* 包含实体（entity）、属性（attribute）和关系（relationship）
* 节点（node）表示实体
* 节点标记以属性（如类型、名称等）
* 边（edge）也有类型，表示实体间的关系

KG示例

```python
'john lennon' is 'person'
'beatles' is 'band'
'liverpool' is 'place'

'john lennon' 'isBornedIn' 'liverpool'
'john lennon' 'isMemberOf' 'beatles'
'beatles' 'isFoundedIn' 'liverpool'
```

## Why KG

对于人类：

* 应对信息过载
* 透过直觉结构探索知识
* 知识驱动型任务的必要工具

对于AI：

* 多种AI任务的关键元素
* 连接数据与人类语义
* 使用过去多年的图分析技术

### 应用实例

1. QA
2. Decision Support
3. Fueling Discovery

### Industry

* Google Knowledge Graph（Vault）
* Amazon Product Graph
* IBM Watson
* Microsoft Satori

## Where do KG come from？

* Structured Text：Wikipedia、数据库等
* Unstructured Text：Web、social media
* Images
* Video

## Knowledge Representation（描述） Choices

多数实现使用RDF三元组（triple）：
* <subject, predicate, object>: r(s, p, o)

ABox (assertions) vs. TBox(terminology)

Common ontological primitives
* rdfs:domain, rdfs:range, rdf:type, rdfs:subClassOf, rdfs:subPropertyOf,
* owl: inverseOf, owl:transitiveProperty, owl:functionalProperty

### Semantic Web（语义网）

define and exchange Knowledge
* RDF、RDFa、JOSN-LD、schema.org
* RDFS、OWL、SKOS、FOAF

标记数据为自动化提供关键资源

问题：annotate everything？

# Part 2 - Knowledge Extraction Primer

## What is NLP

Information Extraction
* entity resolution：同名；昵称；typo；简称；其它code（APPL，GOOG）
* entity linking：candidates gen；entity types；coreference；coherence；
* relation extraction：

Document
* coreference resolution

Sentence
* depencency parsing
* POS tagging
* NER

### Defining Domain

* Manual：Never-ending language learning
* Semi-automatic
* Automatic

## Knowledge Extraction: Key Points

Built on the foundation of NLP techniques:
* POS tagging, dependency parsing, named entity recognition, coreference resolution...
* Challenging problems with very useful outputs

Information extraction techniques use NLP to:
* define the domain
* extract entities and relations
* score candidate outputs

Trade-off between manual & automatic methods

# Part 3 - Graph Construction

Basic problems

* **Who** are the entities(nodes) in the graph?
* **What** are their attributes and types(labels)?
* **How** are they related(edges)

Construction issues

* ambiguous
* incomplete
* inconsistent

## Approach

* clean and complete
* ontological constraints and relational patterns
* discover statistical relationships within knowledge graph

## Probabilistic Models

Classical AI approach: reasoning

Difficult when extracted knowledge has errors



