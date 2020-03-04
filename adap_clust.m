function [fin]= adap_clust(img);
%img=imread('input2.jpg');
k=5;
curr = zeros(k,1);
prev = curr;
img=imresize(img,[256,256]);
img=double(img);
vectr=img(:);
cluster=zeros(length(vectr), k);
maxi=max(vectr);
for j=1:k
    curr(j,1)=j*maxi/k;  %Initialize the Cluster Centers as the index of peaks
end
temp=1;
while(temp==1)
    cluster(1:length(vectr),1:k) = 0;
    % classifying pixels
    for i = 1: length(vectr)
        [val,ind]=min(abs(vectr(i) - curr((1:k),1)));
        cluster(i,ind)= vectr(i);
    end
    prev= curr;
    % updating curr
    for j = 1:k
        curr(j, 1)= sum(cluster(:,j))/length(find(cluster(:,j)));
    end
    if(prev == curr)
        temp = 0;
    end
end

 for clust = 1:k
    fin = reshape(cluster(1:length(vectr),clust:clust), [256,256] );
    imshow(fin,[])
    title('Clusters:')
 end


