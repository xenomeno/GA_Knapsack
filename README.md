# GA
Genetic Algorithm for Knapsack problem

Implementation is in Lua and is based on David E. Goldberg's book "Genetic Algorithms: In Search, Optimization and Machine Learning".

The knapsack problem is the simplified 0-1 version where the weight of an item equals its value, i.e. Wi=Vi. It allows easier description of the problem and this leads to finding the subset of a set of items(numbers) which sum is as close as possible to a given target MAX_WEIGHT. The problem is blind because the GA does not know the values of the items and they are used only when evaluating the chromosome(represented as bitstring with length number of the items). The problem is non-stationary because every few iterations the MAX_WEIGHT target is changed which is only reflected in the fitness evaluation function. Here is a simple problem description:

  {
    title = "Blind Non-Stationary 0-1 Knapsack: Simple",
    Weights = { 25, 95 },
    WeightsPeriod = 25,
    ItemWeights = { 12, 3, 17, 5, 40, 43, 27, 80, 11 },
    max_filename = "Knapsack/Knapsack1_Max",
    avg_filename = "Knapsack/Knapsack1_Avg",
    pop_size = 30,
    max_gens = 400,
  },

It says we are running the GA for 400 iterations and we are alternating the 2 weights 25 and 95 every 25 iterations. The population size is fixed for 30 individuals.

Simple Haploid GA is tested for several knapsacks versus Diploid Bi-Alelic and Tri-Alelic GA. No improvements are made in the algorithm like fitness scaling, ranking, overlapping population, crowd factoring and so on. Only the pure algorithms implementations are tested. The results are saved in a bitmap file which is implemented in pure Lua which is quite slow though.

![](Knapsack1.png?raw=true "")
![](Knapsack2.png?raw=true "")
![](Knapsack3.png?raw=true "")
![](Knapsack4.png?raw=true "")
![](Knapsack5.png?raw=true "")
![](Knapsack6.png?raw=true "")
![](Knapsack1.png?raw=true "")
![](Knapsack7.png?raw=true "")
![](Knapsack8.png?raw=true "")
![](Knapsack9.png?raw=true "")
