%% Equation selection using subset regression
%  2017-09-28  Matlab9.3  Copyright (c) 2017, W J Whiten  BSD License 
% Remove this line, replace xbrx by <br>, nbsp4 by &nbsp &nbsp &nbsp &nbsp
%
% Regression takes a matrix of data columns *A* (independent variables)
% and using a linear combination of these columns predicts a vector
% *b* of dependent values. Each row of *A* can be test measurement values
% and the corresponding element of *b* the result from the test. So the
% regression equations predicts the result of the test from the measurement
% values. A column of ones in *A* provides a constant term in the
% regression equation.
%
% Formally we calculate *x* so that the sum of square errors *Ax-b* is
% minimised. A small sum of squares means *Ax* is a good predictor of *b*.
%
% The back slash operator \ (as x=A\b) or the function linfit 
% ([x,xse]=linfit(A,b)) provides the solution in simple cases. 
% Often many different dependent variables are recorded and it is not
% known which provide the best regression predictions. Choosing the best
% prediction equations is not easy and various methods have been proposed
% (e.g. Subset Selection in Regression, A J Miller, Model Selection,
% H Linhart & W Zucchini). The functions
% demonstrated here investigate all possible subsets
% of the independent variable up to a given size.
% From these subset equations the best equations, of which there 
% may be several, are selected. An initial investigation can be used
% to determine which columns of *A* are important for further 
% analysis.
%
% A summary of the functions follows and then an example is presented. It
% should be noted that probabilities given are only relative due to the
% selection of the best equations. In particular the probabilities for
% the sum of squares errors depend on arbitrary choice of one equation
% as the base. If repeat samples are available these can be used to
% estimate probabilities for the sum of squared errors. Many of the
% functions have optional arguments (see optndfts), use doc function 
% to see details of the function arguments.


%% Summary of main functions
%
% The first function xbrx
% nbsp4 *[AA,nerr]=regmatrix(A,b)* xbrx
% calculates the augmented normal matrix  *AA={A,b]'[A,b]* which is
% used multiple times in the following analysis.
%
% The next step is to calculate candidate
% equations with their sum of squared errors xbrx
% nbsp4  *[vars0,ssq0]=regsubsets(AA,nerr,colsincluded,
% colstoselect,maxselect)*  xbrx
% equations with a low sum of squares up to a maximum number are recorded.
% Columns always included, columns to be selected from, and the maximum 
% number to select can be specified. The number of equations examined
% increases rapidly with the number of columns evaluated and the maximum
% size of equations.
%
% The optional function xbrx
% nbsp4 *[vars1,ssq1,varprob]=regrefine(vars0,ssq0,nerr)* xbrx
% removes equations with insignificant terms and reports a probability
% for each variable (columns of *A*). These probabilities can be used to
% select variables for a rerun of *regsubsets*. As this function removes
% equations with insignificant terms the next stage will run faster.
%
% The next function xbrx nbsp4 
% *[vars2,coef2,sdcoef2,sdres2,crit2]=regreorder(AA,nerr,vars1)* xbrx
% calculates the regression coefficients and selects equations using
% the sum of squared errors, the probability of the coefficients,
% and the regression matrix condition. Optional arguments allow changing
% the values of the selection criteria.
%
% The function xbrx
% nbsp4 *regptinfo(vars2,coef2,crit2,nbrs)* xbrx
% prints a summary of the criteria used to select equations for the
% equations given in vector nbrs, and xbrx
% nbsp4 *regptcoef(vars2,coef2,sdcoef2,nbrs)* xbrx
%  prints the equation coefficients and optionally their standard errors.
%
% The functions xbrx
% nbsp4 *[y,sd]=regequvalue(x,vars2,coef2,sdres2,crit2.chol(:))* xbrx
% evaluates one or more equations using rows of dependent values, and xbrx
% nbsp4 *[z,zsd]=wtmean(y,sd)* xbrx
% combines multiple predictions into a single value with associated 
% standard deviation.
%
% Equations cam also be combined into a single equation xbrx
% nbsp4 *[vars3,coef3,sdcoef3,sdres3,crit3]=
% regequcombine(vars2,coef2,sdres2,crit2,varargin)* xbrx
% This function combines the equations give into a single equation in the
% same format. However evaluating the combined equation is not identical to
% evaluating equations separately and then combining the result.
%
% Three additional functions calculate weights or probabilities used by
% the above functions xbrx
%     *wts=regwtfactors(nvar,nerr,prob)*  in regsubsets xbrx
%     *prob=regprvalues(nerr,nvar,optn.prob)*  in regrefine  xbrx
%     *prob=regssqprob(vars,ssq,nerr,varargin)*  in regreorder   xbrx
%

%% Typical function sequence
%
%     [AA,nerr]=regmatrix(A,b);
%     [vars0,ssq0]=regsubsets(AA,nerr,[],1:21,6,'prob',0.2,'nsave',40000);
%     [vars1,ssq1,varprob]=regrefine(vars0,ssq0,nerr);
%     [vars2,coef2,sdcoef2,sdres2,crit2]=regreorder(AA,nerr,vars1);
%
%     regptinfo(vars2,coef2,crit2,nbrs)
%     regptcoef(vars2,coef2,sdcoef2,nbrs)
% 
%
%     [y,sd]=regequvalue(x,vars2,coef2,sdres2,crit2.chol(:))
%     [wm,wsd,dist]=wtmean(x,sd,rpts)
% 

%% Generate some test data
% Initial values for random number generator and the number of errors
rng(10)
nerr=100;

%%
% The independent variables consist of 4 columns of random variables, 
% 7 columns of combinations of these, and 10 more columns of random
% variables. The dependent vector is sum of first four columns plus a 
% random term. Finally a small random term is added to the columns of
% independent variables and ten additional columns of random terms are
% appended to the independent variables.

A=randn(nerr,4);
A=[A,A(:,1)+A(:,2),A(:,3)+A(:,4),A(:,1)+A(:,3),  ...
    A(:,2)+A(:,4),A(:,1)+A(:,4),A(:,2)+A(:,3),  ...
    A(:,1)+A(:,2)+A(:,3)+A(:,4)];

r1=randn(nerr,1);
r1=r1/std(r1);
b=sum(A(:,1:4),2)+0.1*r1;

r2=randn(nerr,size(A,2));
r2=r2./std(r2);
A=[A+0.01*r2,randn(nerr,10)];

%%
% There are now 43 possible simple combinations of these columns of *A*
% that predict the vector *b*,
% of these 11 are simple positive combinations of the columns, and
% there are 4 more positive combination of the columns.
% The remaining cases have negative coefficients or small coefficients. 
% Further possible prediction equations can be formed from pairs of the
% 43 simple combinations and by appending other columns to the prediction
% equations.
%
% The last ten random columns have no relation with the dependent variable
% and should be rejected by the column selection criteria.

%% Generate the augmented normal matrix:  *regmat*
% Several of the subsequence calculations use the augmented normal matrix
% *AA=[A,b]'*[A,b];* and for efficiency it is generated once initially
% as:

[AA,nerr]=regmatrix(A,b);

%%
% Both the matrix *AA* and the number of error terms *nerr* are used
% by the following functions.
% The optional third input argument, gives weighting for the rows of *A*
% and *b*. 1 specifies weighting for a likelihood bootstrap, 2 specifies a
% classical selection bootstrap, A vector of weights can also be given.
% The bootstraps give a perturbed, but still typical matrix, that can be
% used in bootstrap analyses to examine typical variation in the
% regression results.

%% Determine equations based on error size:  *regsubsets*
% The function *regsubsets* calculates the sum of squared errors for
% all the subsets up to the specified number of terms.
% The third input argument is column numbers of variables to 
%  always include (none in this case), the fourth is variables to be
%  included in the equation search, and the fifth the maximum number of 
%  variables from the fourth argument to include. The number of possible
% equations searched rapidly becomes large if more columns and more
% variables are allowed in the equations, and the run time increases.
% For long run times progress is noted.

[vars0,ssq0]=regsubsets(AA,nerr,[],1:21,3);
disp(' ')
disp('Initial search by regsubsets')
disp(['Nbr of equations ',num2str(length(ssq0)),'   Max variables ',  ...
    num2str(size(vars0,2))])

%%
% *regsubsets* selects the equations to save based on the sum of squared
% fit errors biased for the number of variables in the fitted equations.
% In cases where there are a number of possibly irrelevant independent
% variables it might advantageous to increase the number of equations
% saved with the 'nsave' option (see optndfts function).

%% Optional reduction of number of equations: *regrefine*
% *regrefine* removes equations with insignificant terms using the 
% sum of squared errors and a F-test, and gives information on the
% dependent columns potential usefulness in prediction. This
% information can be used to better select columns to use in *regsubsets*,
% and thus significantly reduce number of equations to
% be examined by *regreorder*

[vars1,ssq1,varprob]=regrefine(vars0,ssq0,nerr);
disp(' ')
disp('Refine the number of equations retained using regrefine')
disp(['Nbr of equations ',num2str(length(ssq1)),'   Max variables ',  ...
    num2str(size(vars1,2))])
disp('varprob')
disp(varprob)

%%
% The vector *varprob* estimates the probability that each
% variable has an effect similar to a random column of independent
% predictors, with near zero indicating useful variables.
% Here we see the first 11 columns are significant and
% the last 10 are, as might be expected, not better than a random
% column for predicting the dependent column.

%% Reduced variables in equation selection
% Having estimated which variables are potentially useful in the
% regression we can look at equations made up using these variables. With
% less variables we can search for equations with more terms (in this
% case 6) without using excessive computation time. so the two functions
% from above are run a second time:

[vars0,ssq0]=regsubsets(AA,nerr,[],1:11,6);
[vars1,ssq1,varprob]=regrefine(vars0,ssq0,nerr);
disp(' ')
disp('Deeper search with less variables: regsubsets regrefine')
disp(['Nbr of equations ',num2str(length(ssq1)),'   Max variables ',  ...
    num2str(size(vars1,2))])

%% Calculate coefficients and select equations:  *regreorder*
% Having reduced the number of possible equations *regreorder* calculates
% coefficients, standard error values, and selects equations that satisfy
% several criteria.

[vars2,coef2,sdcoef2,sdres2,info2]=regreorder(AA,nerr,vars1);
disp(' ')
disp('Further selection and coefficient calculation: regreorder')
disp(['Nbr of equations ',num2str(size(vars2,1)),'   Max variables ',  ...
    num2str(size(vars2,2))])

%%
% Equations are selected on size of standard deviation of residuals,
% probability of least significant coefficient, and maximum ratio of
% elements on diagonal of Cholesky matrix (a measure of conditioning of
% the equation), and if desired using a probability like measure of the
% standard deviation of the residuals. The level for these tests can be
% set by the user using optional arguments  (see doc regreorder).

%% Print results: *regptinfo* *regptcoef*
% Two functions are provided to display the results. *regptinfo* prints
% summary of the equations and selection criteria.

disp(' ')
disp('Summary of results: regptinfo')
regptinfo(vars2,coef2,info2,1:50);

%%
% The last argument selects the indices of equations to be printed if
% they exist. The column labelled probssq is a probability like estimate
% for the sum of squared errors and error standard deviation. As the
% number of error terms increases it becomes very sensitive to changes
% in error values and number of terms in the equation, often the standard
% deviation of the residues is a better indicator for equation selection.
% In the three columns probssq, probcoef, and cholratio
% larger values indicate a better equation.
%
% The function *regptcoef* prints the coefficients and optionally the
% standard errors of the coefficients.

disp(' ')
disp('Some coefficient values: regptcoef')
regptcoef(vars2,coef2,sdcoef2,1:10)

%%
% If the sdcoef argument is omitted the standard deviations are not
% printed. The last argument selects the equations to print.


%% Select positive coefficients
% All the smaller prediction equations have positive coefficients
% near one. The equations with larger positive coefficients are selected.

[vars3,coef3,sdcoef3,sdres3,info3]=  ...
    regreorder(AA,nerr,vars1,'coefmin',0.6);
disp(' ')
disp('Restrict to coefficients >0.6 via regreorder')
regptinfo(vars3,coef3,info3,1:50)

%% Evaluating equations:  *equvalue*
% The function *equvalue* given values of the independent variable
% calculates the estimated dependent variable. The function *wtmean*
% combines multiple estimates into a single value.

disp(' ')
disp('Evaluate first 5 equations for first 7 data points: regequvalue')
indd=1:7;
inde=1:5;
[y,ysd]=regequvalue(A(indd,:),vars3(inde,:),coef3(inde,:),  ...
    sdres3(inde),info3.chol(inde)) %#ok<NOPTS>

disp('Combine values: mean and std dev')
[z,zsd]=wtmean(y,ysd);
disp([z,zsd])


%%
% Note here *wtmean* calculates the standard deviation is calculated
% as a combination of that from the individual standard deviations
% and the standard deviation of the individual values.
%
% The residual errors are calculated by subtracting the dependent variable
% from the predictions

r=regequvalue(A,vars3(inde,:),coef3(inde,:))-b;
disp(' ')
disp('Standard deviation of residual columns')
std(r)

%%
% The standard deviations are similar to that of those added to the
% dependent variable. 
% 

%% Equations can also be combined
% It is likely that a combination of the equations gives a better
% prediction than a single equation. the function *regequcombine* combines
% the multiple equations output from *regreorder* to give a single equation.

[vars4,coef4,sdcoef4,sdres4,info4]=  ...
    regequcombine(vars2,coef2,sdres2,info2);
disp(' ')
disp('Combined equation coefficients and their standard deviations')
regptcoef(vars4,coef4,sdcoef4,1);


%% Run *linreg* as check
% Compare result with a simple linear regression program.

disp(' ')
disp('Compare a result with with simple linear regression')
t1=11;
t2=vars3(t1,1:sum(vars3(t1,:)>0));
[x,sd,rse,L]=linfit(A(:,t2),b);
disp('Linreg coef & sds')
disp([x';sd'])
disp('Reg... coef & sds')
disp([coef3(t1,t2);sdcoef3(t1,t2)])
disp('Linreg & Reg... std dev error')
disp([rse,sdres3(t1)])

%% Bootstrap calculations
% A Bootstrap creates additional data sets with similar statistical 
% properties to the original. These data sets can be used to determine 
% which equations are consistently chosen as predictors of the dependent 
% variable. In this case the equations found have been limited to those
% with positive coefficients. Each of ten repeats finds multiple
% equations of which only the equations found in all of the
% repeats are retained.

% initial list of equations to select from
varsb3=vars0;

disp(' ')
disp('Equations from bootstrap selection')
disp(' Found  Reduced')
for i=1:10
    
    % generate bootstrap sample and find equations
    [AAb,nerr]=regmatrix(A,b,1);
    [varsb1,~]=regsubsets(AAb,nerr,[],1:11,6);
    [varsb2,~,~,~,~]=regreorder(AAb,nerr,varsb1,'coefmin',0);
    
    % eliminate equations not found in all repeats
    [varsb3,p1,~]=intersect(varsb3,varsb2,'Rows');
    
    disp([size(varsb2,1),size(varsb3,1)])
end

% update with original normal matrix
[varsb2,coefb2,sdcoefb2,sdresb2,infob2]=  ...
    regreorder(AA,nerr,varsb3);
regptinfo(varsb2,coefb2,infob2,1:50)

%% Use leave some out to estimate residual size
% The data is randomly permutated then each tenth of the data is removed
% and the equations fitted on the remaining data. The residues are then
% predicted for the tenth of data not included in the fit. The standard
% deviation of the residues is used as a basis for estimation of the
% probabilities for the sum of squared residues for each equation. Note
% that these probabilities are vary sensitive to the base used.

nsect=10;
sd1=zeros(nsect,1);
k1=[1,round((1:nsect)*(nerr+1)/nsect)];

nrep=100;
sd2=zeros(nrep,1);
for j=1:nrep
    rp=randperm(nerr);
    for i=1:nsect
        rp1=rp(k1(i):k1(i+1)-1);
        wts=ones(nerr,1);
        wts(rp1)=0;
        AAb=regmatrix(A,b,wts);
        [varsb2,coefb2,~,~,~]=regreorder(AAb,nerr,varsb2);
        sd1(i)=rms(std(regequvalue(A(rp1,:),varsb2,coefb2)-b(rp1)));
    end
    
    sd2(j)=rms(sd1);
end

sd3=rms(sd2);

disp(' ')
disp(['Estimated (leave some out) std dev of data  ',num2str(sd3)])
disp('Probabilities for the 15 equations')
prob=regssqprob(varsb2,infob2.ssq,nerr,'ssq0',sd3^2*nerr)' %#ok<NASGU>


%% Use weighted likelihood bootstrap to estimate residual size
% The data is weighted to give typical variation in the results. The lowly
% weighted data is then used to estimate the standard deviation of the
% data. Again probabilities for the 15 equations are calculated

nrep=1000;
sd1=zeros(nrep,1);
for i=1:nrep
    [AAb,nerr,w]=regmatrix(A,b,1);
    [varsb2,coefb2,~,~,~]=regreorder(AAb,nerr,varsb2);
    ind=w<0.4568;
    sd1(i)=rms(std(regequvalue(A(ind,:),varsb2,coefb2)-b(ind)));
end

sd2=rms(sd1);

disp(' ')
disp(['Estimated (weighted likelihood bootstrap) std dev of data  ',num2str(sd2)])
disp('Probabilities for the 15 equations')
prob=regssqprob(varsb2,infob2.ssq,nerr,'ssq0',sd2^2*nerr)' %#ok<NASGU>

%% Use classical selection bootstrap to estimate residual size
% Data is weighted by selection giving integer weights. In this case the
% zero weighted data is used to estimate the data standard deviation. 
% Probabilities for the equations are again estimated.
nrep=1000;
sd1=zeros(nrep,1);
for i=1:nrep
    [AAb,nerr,w]=regmatrix(A,b,2);
    [varsb2,coefb2,~,~,~]=regreorder(AAb,nerr,varsb2);
    ind=w<0.4568;
    sd1(i)=rms(std(regequvalue(A(ind,:),varsb2,coefb2)-b(ind)));
end

sd2=rms(sd1);

disp(' ')
disp(['Estimated (selection bootstrap) std dev of data  ',num2str(sd2)])
disp('Probabilities for the 15 equations')
prob=regssqprob(varsb2,infob2.ssq,nerr,'ssq0',sd2^2*nerr)' %#ok<NOPTS>

%%
% While the data standard deviation can be estimated, repeated data values
% can provide better information on the accuracy of the data.