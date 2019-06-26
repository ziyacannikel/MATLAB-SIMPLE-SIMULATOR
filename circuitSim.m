fid = fopen('deneme.txt');
data = textscan(fid,'%s %f %f %f');
symbols=data{1}; %column1
c1=data{2}; %column2
c2=data{3}; %column3

c3=data{4}; %column4
row_num=length(c2); % row number
sum =[c1 c2 c3];
n = max(c2);% node number 
disp('firstly voltage sources then current sources last resistors should be placed in the text file ')
 vsrc_num = input('number of independent voltage sources :');
 isrc_num = input('number of independent current sources :');
 
 yedek = sum; % only resistor values
 
 for i=1:1:vsrc_num+isrc_num
  yedek(1,:)=[];   
 end
 
 for i=1:1:(row_num-(vsrc_num+isrc_num))
     yedek(i,3)=1/yedek(i,3); 
 end
 
 gmatrix=zeros(n,n); %create  n*n zero matrix
 
 % an algorithm for g matrix terms on diagonal
 cnt=1; % control number
 while cnt < n+1
  for i=1:1:n
    for j=1:1:2
        if yedek(i,j)== cnt
            gmatrix(cnt,cnt)=gmatrix(cnt,cnt)+yedek(i,3);
        end
    end
  end
  cnt=cnt+1;
 end
 
 %other part of g matrix
 cnt=1; % control number
 while cnt < n+1
  for i=1:1:n
   
        if yedek(i,1)~= 0
            gmatrix(yedek(i,1),yedek(i,2))= yedek(i,3)*-1;
            gmatrix(yedek(i,2),yedek(i,1))= yedek(i,3)*-1;
        end
    
  end
  cnt=cnt+1;
 end
 
 yedek=sum;
 
  for i=1:1:row_num-vsrc_num
  yedek(vsrc_num+1,:)=[];   
  end
  
bmatrix=zeros(n,vsrc_num); %create  a zero matrix

  % an algorithm for b matrix terms 
 for i=1:1:vsrc_num
     for j=1:1:2
        if yedek(i,j)~=0 & j == 1
            bmatrix(yedek(i,j),i)=-1;
        end    
        if j==2
            bmatrix(yedek(i,j),i)=1;
        end
     
     end
 end
  
 cmatrix = transpose(bmatrix);
 dmatrix=zeros(vsrc_num,vsrc_num); %create  a zero matrix
 amatrix=[gmatrix bmatrix ; cmatrix dmatrix];
 
 yedek=sum;
 
 yedek=yedek(vsrc_num+1:vsrc_num+isrc_num, 1:3);
 imatrix=zeros(n,1); %create  a zero matrix
 
 for i=1:1:isrc_num
     for j=1:1:2
         if yedek(i,j)~=0 & j==1
           imatrix(yedek(i,j),1)= imatrix(yedek(i,j),1)-yedek(i,3);
         end
         if j==2
           imatrix(yedek(i,j),1)=imatrix(yedek(i,j),1)+yedek(i,3);  
         end 
     end
 end
 
 yedek=sum;
 if vsrc_num ~=0
 ematrix=zeros(vsrc_num,1); %create  a zero matrix 
   for i=1:1:vsrc_num
     ematrix(i,1)=yedek(i,3);
   end
   zmatrix=imatrix;
   for i=1:1:vsrc_num
       zmatrix(i+n,1)=ematrix(i,1);
   end
 
 
    zmatrix=[imatrix ; ematrix];
 end
 
if vsrc_num ==0
    zmatrix=imatrix;
end

% A AND Z MATRÝXES ARE READY TO USE 
% X = A^-1*Z

xmatrix=inv(amatrix)*zmatrix;

for i=1 :1:n
    fprintf('VR%d\n',i)
    fprintf('%d\n',xmatrix(i,1))
    disp(' ')
end


for i=1 :1:vsrc_num
    fprintf('I%d\n',i)
    fprintf('%d\n',xmatrix(n+i,1))
    disp(' ')
end











 
 
 
 
 
 
 
 
 
 
    
 
 



