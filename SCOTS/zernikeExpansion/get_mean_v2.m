function x_mean=get_mean_v2(x,weight)
%
% This function returns the weighted mean of the array x. NaN values are
% ignored in the computation and are NOT replaced by zeros. This function
% can therefore be used for computations over pupils masked with NaN's. The
% average is performed over both dimensions of x at the same time.
%
% Usage: x_mean=get_mean_v2(x,weight)
%
% x contains the values from which the average should be computed. It's a
% [MxN] array with M,N>=1.
% 
% weight contains the weights associated with the values of x. The elements
% of weight must be located at the same indices as the corresponding values
% of x. If all the values have the same weight, the following are
% equivalent:  weight=ones(size(x))  or  weight=[]  .
%
%
% x_mean is the mean value of the 2D array.
%
% Equivalent to Matlab's "nanmean.m" with: x_mean=nanmean(x.*weight)
%
% Last update: 04/03/2013

if(isempty(weight))
    weight=ones(size(x));
end

[size1,size2]=size(x);

map_nan=isnan(x);
nb_nan=sum(sum(map_nan));
if(nb_nan==0)
    x_ordered=reshape(x,size1*size2,1);
    weight_ordered=reshape(weight,size1*size2,1);
else
    x_ordered=zeros(size1*size2-nb_nan,1);
    weight_ordered=zeros(size1*size2-nb_nan,1);
    compteur=0;
    for tt=1:1:size1
        for kk=1:1:size2
            if(map_nan(tt,kk)==0)
                compteur=compteur+1;
                x_ordered(compteur)=x(tt,kk);
                weight_ordered(compteur)=weight(tt,kk);
            end
        end
    end    
end

if(nb_nan<size1*size2)
    x_mean=sum(x_ordered.*weight_ordered)/sum(weight_ordered);
else
    x_mean=NaN;
end