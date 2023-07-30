function x_RMS=get_mean_RMS_v2(x,weight)
%
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

x_mean=get_mean_v2(x,weight);

if(nb_nan<size1*size2)
    x_RMS=sqrt( sum(weight_ordered.*(x_ordered-x_mean).^2)/sum(weight_ordered) ); % check where to introduce the weight
else
    x_RMS=NaN;
end