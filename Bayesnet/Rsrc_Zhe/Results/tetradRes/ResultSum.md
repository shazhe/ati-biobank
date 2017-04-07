# Summary of the results using Tetrad
Using GES + PC LinGam

Results saved in /home/fs0/zhesha/ukbb/ati-biobank/Rsrc_Zhe/Results/

### 41 Risk factors and IDP clusters
#### 38 IDPs -- most variance
1. workspace results: V79m.tet

2. Graph file: the graph matrices are saved in graph1.r.txt, graph2.r.txt and graph3.r.txt

3. Running time:
* GES: search > 5min, Calc Stats (NA) and failed so use Cut F both < 10s
* PC LinGam: search < 10s, Clac Stats ~ 5min

4. Statistics(Slow to calculate)

* GES: Degrees of Freedom = 2991, Chi-Square = 44,226.4267
       P Value = 0,  BIC Score = 18,996.9975


* PC LinGam: This use 20 CPU and > 20% of memory while runing and takes more
  than 10min, apparently not suitable for larger datasets.
  Degrees of Freedom = 2682 Chi-Square = 7,403.1965, P Value = 0
  BIC Score = -15,219.7822


5. Bootstrap stability only tried 2 replications because manually doing the
   process is laborous and takes a lot of time.
   * Adjacency Matrices saved in txt files
   * Pairwise comparison with the original data saved in the tetrad workspace


#### 38 IDPs -- average variance
1. workspace results: V79a.tet

2. Graph file:

3. Running time:
* GES:
* PC LinGam:

4. Statistics

* GES:
* PC LinGam: same

5. Bootstrap stability
