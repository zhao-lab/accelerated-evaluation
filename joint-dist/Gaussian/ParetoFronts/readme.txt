The main file of this package is paretofronts.m

All of the other files are auxiliary functions

PARETOFRONTS from a set of points x with a certain dominance relation dom 
  
  [M,F] = PARETOFRONTS(x,objective,dom,make_plot,parameter) can find and/or 
  plot the first or all the pareto fronts according to one of 7 relations 
  of dominance among points of any dimension 
  
  Inputs: 
     x = table with point in format (N, M) where N is the number of 
     points and M is their dimension 
  
     objective = array specifying if we want to minimize (0) or maximize (1) 
                 each dimension (default = 1) 
  
     dom = string or number with a dominace relation (default = pareto 
                    dominance) 
           possible values: 1 - 'pareto' 
                    2 - 'lexicographic' 
                    3 - 'extrema' 
                    4 - 'maxdom' 
                    5 - 'cone' 
                    6 - 'epsilon' 
                    7 - 'lorenz' 
  
     make_plot = 0, 1 or 2, plots the points and their fronts 
  
     parameter = available for 'lexicographic' (rank of importance between objectives of length M) 
                    'extrema' (weight vector for each objective of length M) 
                    'epsilon' (epsilon > 0, resolution vector of length M or 1) 
                    'cone' (inclination value lambda (default value is 0.2) of length 1) 
  
  
  Outputs: 
     M = list with which elements are in the first front 
     F = list with the front of each element 
  
  Examples: 
   
  members = paretofronts(randn(100,3),[1,1,1],1,1); 
  
  [members, fronts] = paretofronts(randn(100,2),[0,0],1,1); 
  
  x = randn(50,2); for i=1:7 subplot(2,4,i); paretofronts(x,[0,0],i,1); end 