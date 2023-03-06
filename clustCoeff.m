function [C1,C2, C] = clustCoeff(A)
%CLUSTCOEFF Compute two clustering coefficients, based on triangle motifs count and local clustering
% C1 = number of triangle loops / number of connected triples
% C2 = the average local clustering, where Ci = (number of triangles connected to i) / (number of triples centered on i)
% Ref: M. E. J. Newman, "The structure and function of complex networks"
% Note: Valid for directed and undirected graphs
%
% @input A, NxN adjacency matrix
% @output C1, a scalar of the average clustering coefficient (definition 1). 
% @output C2, a scalar of the average clustering coefficient (definition 2). 
% @output C, a 1xN vector of clustering coefficients per node (where mean(C) = C2).  
%
% Other routines used: degrees.m, isDirected.m, kneighbors.m, numEdges.m, subgraph.m, loops3.m, numConnTriples.m

% Updated: Returns C vector of clustering coefficients.

% IB, Last updated: 3/23/2014
% Input [in definition of C1] by Dimitris Maniadakis.



n = length(A);
A = A>0;  % no multiple edges
[deg,~,~] = degrees(A);
C=zeros(n,1); % initialize clustering coefficient

% multiplication change in the clust coeff formula
coeff = 2;
if isDirected(A); coeff=1; end

for i=1:n
  
  if deg(i)==1 || deg(i)==0; C(i)=0; continue; end

  neigh=kneighbors(A,i,1);
  edges_s=numEdges(subgraph(A,neigh));
  
  C(i)=coeff*edges_s/(deg(i)*(deg(i)-1));

end

C1=3*loops3(A)/(numConnTriples(A)+2*loops3(A));
C2=sum(C)/n;



%% subfunctions

function [deg,indeg,outdeg]=degrees(adj)

indeg = sum(adj);
outdeg = sum(adj');

if isDirected(adj)
  deg = indeg + outdeg; % total degree

else   % undirected graph: indeg=outdeg
  deg = indeg + diag(adj)';  % add self-loops twice, if any

end


function S=isDirected(adj)

S = true;
if adj==transpose(adj); S = false; end


function S = isSymmetric(mat)

S = false; % default
if mat == transpose(mat); S = true; end


function neighbors = kneighbors(A,ind,k)
%KNEIGHBORS Finds the adjacency list of nodes at distance k from 'ind'
%
% @input A, NxN adjacency matrix
% @input ind, a scalar node # of the search index
% @input k, a scalar for distance to search
% @output neighbors, a adjacency list of nodes reachable from 'ind' in 'k' hops 
% INPUTS: adjacency matrix (nxn), start node index, k - number of links
% OUTPUTS: vector of k-neighbors indices
%
% Updated: For readability.

% IB: last updated, 3/23/14

adjk = A;
for i=1:k-1 
    adjk = adjk*A; 
end;

neighbors = find(adjk(ind,:)>0);


function L3 = loops3(adj)

L3 = trace(adj^3)/6;   % trace(adj^3)/3!


function c=numConnTriples(adj)

c=0;  % initialize

for i=1:length(adj)
    neigh=kneighbors(adj,i,1);
    if length(neigh)<2; continue; end  % handle leaves, no triple here
    c=c+nchoosek(length(neigh),2);
end

c=c-2*loops3(adj); % due to the symmetry triangles repeat 3 times
                   %                        in the nchoosek count


function m = numEdges(adj)

sl=selfLoops(adj); % counting the number of self-loops

if isSymmetric(adj) & sl==0    % undirected simple graph
    m=sum(sum(adj))/2;
    
elseif isSymmetric(adj) & sl>0
    m=(sum(sum(adj))-sl)/2+sl; % counting the self-loops only once

elseif not(isSymmetric(adj))   % directed graph (not necessarily simple)
    m=sum(sum(adj));
    
end


function sl=selfLoops(adj)

sl=sum(diag(adj));


function adj_sub = subgraph(adj,S)

adj_sub = adj(S,S);




