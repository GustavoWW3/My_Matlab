function y = corr(x)
%CORR	Correlation matrix. 
%	For a matrix X where each row is an observation, and each column a
%	variable, if COV is the covariance matrix, then CORR(X) is the matrix
%	whose (i,j)'th element is   COV(i,j)/SQRT(COV(i,i)*COV(j,j)).
%	See also COV and STD.
c = cov(x);
d = diag(c);
y = c./sqrt(d*d');


