# Summary of Week 3 Presentation
------
## Introduction: Data and Goals

### UK Biobank data
* participants: 500,000 (total); 5847(with scanned images and included in our data)
* variables (7404 included in our data)
  * MRI scans (processed)
  * life style: smoke, diet, etc
  * health and biomarkers: disease, blood preasure, etc
  * orther chracteristics

### Goals: detecting causal relationships among the variables
1. Unconstrained analysis: use all variables with appropriate reduction of dimensionality
2. Hypothesis driven: use a small group of variables selected by experts and test specific hypothesis of causal relations

------
## Current Progress

### Data Cleaning
* Major task now and much work has been done by Alex and Alkeos

* Details elaborated later

### Formulating Hypothesis
* Gwen has been checking all intresting variables and proposed a few groups of variables driven by hypotheses

### Causal Models
* Zhe and Alkeos try to learn more tools for testing causal relationships and fitting causal models, esp Bayesian network

* Now use part of the Biobank data and sythetic data for testing code

------

## Data cleaning process and issues
1. Missing Data

    * artificial missingness -- from nested questions
  
	> *Example: Drink Coffee? If yes, what type?*
  
    * How to impute? -- longitudinal, categorical, numerical data

2. Longitudinal variables (variables with multiple visits)
    * mismathed time-span and irregularly spaced -- how to compare, interpolate or aggregate?
    * missing values

3. Multiple entries for a single question
    * how to represent these variables ?
    * how to treat each possible answers ?

> *Examples 1: Leasure activities*
        
> *Example 2: Diagnosis*

4. Orthers messiness -- how to spot them?
    * bad encoding of levels of categorical variables
    
> *Example: how often do you smoke?*
   
    * inconsistent answers
    
> *Example: never smoked and used to smoke everyday.*

------

## Future Work

1. Reducing dimensionality
   * Analysing correlations
   * Sparse approach
   * Projection approach (PCA/ICA/CCA)
   * Variables clustering

2. Causal Inference
    * Methodology: assumptions and procedures; how to deal with confoundings? etc
    * Modelling: how to model or transform descrete variables and categorical variables?
    * implementation: software packages and computational bottleneck for large network data
