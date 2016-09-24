# The Little Schemer, 4th Edition

	
# Transparent ML Technoques

## Dictionary

* A dict(gazetteer) contains terms for a particular concept
* Very important for IE tasks
	- List of country names, cities, common first names, org suffixes
	- Highly data dependent -> crucial for domain adaption

### General Approaches (P52)

* Dict learning
	- Semi-supervised: often used in practice/bootstrapping. (P53)
	- Unsupervised (P55)
* Dict refinement

### Term Ambiguity Detection (P56)

## Regex

* Essential to many IE tasks
* Writing regexes for IE is not straightforward

### Learning Regex

* Supervised (positive and negative, P61) [Li et al., EMNLP 2008]
* Semi-supervised (positive only, P68) [Brauer et al. 2011]

## Rules (+ Classifier)

### Fact Extraction

* Traditional IE
* Open IE [Banko et al. 2007]

* Earlier work: Sequence patterns (CPSL-style) as target language
* Recent work: Predicate-based rule program as target language



