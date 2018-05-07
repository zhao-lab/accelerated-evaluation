x = rand(100,1);
y = rand(100,1);



x = round(x,1);
y = round(y,1);

[table,a,p] = crosstab(x,y);
%%
t = [0 1 2 3 4 5];
points = [0 0; 1 0; 1 1; 0 1; 0 2; 1 2];
x = points(:,1);
y = points(:,2);
% calculate spline for way points
tq = 0:0.11233:5;
xq = interp1(t,x,tq,'spline');
yq = interp1(t,y,tq,'spline');
plot(x,y,'o',xq,yq,':.');
%%
x = '';
value = {'some text';
         [10, 20, 30];
         magic(5)};
s = struct(field,value);

%%

cHeader = {'ab' 'bcd' 'cdef' 'dav'}; %dummy header
commaHeader = [cHeader;repmat({','},1,numel(cHeader))]; %insert commaas
commaHeader = commaHeader(:)';
textHeader = cell2mat(commaHeader); %cHeader in text with commas
header2 = ['a,b,c,d,'];
%write header to file
fid = fopen('yourfile.txt','w'); 
fprintf(fid,'%s\r\n',header2)
fclose(fid)
%write data to end of file
ttt= rand(4);
dlmwrite('yourfile.txt',ttt,'-append','newline','pc');
dlmwrite('yourfile.txt',textHeader,'-append','newline','pc');

%% plot the half sine curve 
w = 3.4;
x = -10:0.01:40;
y = 0.5*w*sin((x-15)./15*3.14/2)+0.5*w;
y(x<0) = 0;
y(x>30) = w;
plot(x,y,'r-','linewidth',1.5)
hold on 
plot (min(x)-1,min(y)-1)
plot (max(x)+1,max(y)+1)
axis equal

y1 = ones(size(x))*-0.5*w;
y2 = ones(size(x))*0*w;
y3 = ones(size(x))*0.5*w;
y4 = ones(size(x))*1*w;
y5 = ones(size(x))*1.5*w;

plot(x,y1,'k-','linewidth',2)
% plot(x,y2,'b--')
plot(x,y3,'y-.','linewidth',2)
% plot(x,y4,'b--')
plot(x,y5,'k-','linewidth',2)
set(gca,'Color',[0.8 0.8 0.8]);