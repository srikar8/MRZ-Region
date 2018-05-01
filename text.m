clear all;
close all;
clc;

I = imread('Passport.jpg');
I=imresize(I,[NaN 1000]);
figure, imshow(I);
I = rgb2gray(I);
[row,col]=size(I);
z=zeros(row,col);
%figure, imshow(I);


for i= 2:row-1
    for j=2:col-1
        if i==1 || i==row || j==1 || j==col
        z(i,j)=I(i,j);
        else
        z(i,j)=(I(i,j)*8) - I(i-1,j-1)- I(i-1,j+1)- I(i-1,j) - I(i,j-1) - I(i,j+1)- I(i+1,j-1)-I(i+1,j)-I(i+1,j+1); 
        end
    end
end
%figure,imshow(z);
I=I+uint8(abs(3*z));

%I= imcrop(I,[243 58 489 627]);
I=imresize(I,2);

%figure, imshow(I);
[row,col]=size(I);
a=zeros(row,col);
for i= 1:row
    for j=1:col
        if I(i,j)<100
            a(i,j)=1;
        else
            a(i,j)=0;
        end
    end
end

SE=strel('rectangle',[2 2]);
k=imclose(a,SE);
SE=strel('rectangle',[1 1]);
k=imopen(k,SE);
%figure, imshow(k);
k=imbinarize(k);
SE=strel('rectangle',[30 30]);
k=imclose(k,SE);
k=imopen(k,SE);
k=imfill(k,'holes');

figure, imshow(I);

   track_objects = regionprops(k,'basic');
        n_centroid = cat(1,track_objects.Centroid);

        hold on 
         for index = 1:length(track_objects)
             bbMatrix = vertcat(track_objects(index).BoundingBox);
             if (bbMatrix(:,3)/bbMatrix(:,4))>=12 && (bbMatrix(:,3)/bbMatrix(:,4))<15
                 box = track_objects(index).BoundingBox;
                 plot(track_objects(index).Centroid(1),track_objects(index).Centroid(2),'b*');
                 rectangle('position',box,'Edgecolor','green','LineWidth',2);
                 w=index;
             end
         end
         hold off
         bbMatrix = vertcat(track_objects(w).BoundingBox);
         pX = (bbMatrix(:,1) + bbMatrix(:,3)) * 0.008;
			pY = (bbMatrix(:,2) + bbMatrix(:,4)) * 0.008;
			x = bbMatrix(:,1) - pX;
            y = bbMatrix(:,2) - pY;
			w= bbMatrix(:,3) + (pX * 2);
            h= bbMatrix(:,4) + (pY * 2);
           MRZ=I( y:y + h, x:x + w);
           figure,imshow(MRZ);
            bw=MRZ;
            [row,col]=size(bw);
            lk=zeros(row,col);
            for i= 1:row
                for j=1:col
                    if bw(i,j)>70
                        lk(i,j)=0;
                    else
                        lk(i,j)=1;
                    end
                    
                end
            end
            
            SE=strel('rectangle',[2 2]);
            
            lk=imclose(lk,SE);
            SE=strel('rectangle',[1 1]);
             lk=imerode(lk,SE);
            
            
            figure,imshow(lk);
            results = ocr(lk);
           
