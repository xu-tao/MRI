clear all;
clc;

load test_set;

% transferring image data into k-space data
% A=abs(ifft2(input(:,:,1))); %undersampling data
B=ifft2(label(:,:,1)); %non-undersampling data

% shifting low-frequency k-space data into the center
% C=ifftshift(A);
D=ifftshift(B);

%--------------------------------------------------------------------------
% linear phase encode undersampling
% P=zeros(256);
% for i=1:size(D,1)
%     for j=1:size(D,2)
%         k=mod(i,2); % sampling every two lines
%         if k==0
%             P(i,j)=D(i,j,1);
%         else
%             P(i,j)=0;
%         end
%     end
% end

%--------------------------------------------------------------------------
% spiral undersampling 4-fold
P=zeros(256);
Q=zeros(256);

for i=128-25:128+25
    for j=128-25:128+25
        P(i,j)=D(i,j,1); % P is used for spiral undersampling
        Q(i,j)=D(i,j,1); % Q is used for 4% undersampling
    end
end

count=1;
corx=128;
cory=128;
for l=4:4:254
    if mod(count,2)==1
        k=1;
    else
        k=-1;
    end
    
    for i=1:l
        P(corx+i*k,cory)=D(corx+i*k,cory,1);
    end
    corx=corx+i*k;

    for j=1:l
        P(corx,cory+j*k)=D(corx,cory+j*k,1);
    end
    cory=cory+j*k;
    count=count+1;
end

%--------------------------------------------------------------------------
% tranferring undersampled k-space data into image data
M=abs(ifft2(ifftshift(P)));
N=abs(ifft2(ifftshift(Q)));

%--------------------------------------------------------------------------
% draw figures
figure

subplot(2,3,1)
imshow(label(:,:,1))
title('100% sampling');
subplot(2,3,4)
imshow(D*1500)

subplot(2,3,2)
imshow(imrotate(M,180)*70000)
title('4-fold spiral');
subplot(2,3,5)
imshow(abs(P)*1500)

subplot(2,3,3)
imshow(imrotate(N,180)*70000)
title('4% undersampling');
subplot(2,3,6)
imshow(abs(Q)*1500)