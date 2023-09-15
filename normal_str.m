clear all;
clc;

[fid] = fopen('stress.300K.out');
 
line_1 = fgetl(fid);
line_2 = fgetl(fid);
line_3 = fgetl(fid);

stress(1,1:10) = 0;

for i=1:800
    
    [ts,count] = fscanf(fid, '%f',[1,3]);

    [data,count] = fscanf(fid, '%d %f %f %f %f %f %f %f %f %f ',[10,250]);
     data = data';
         
    stress = cat(1, stress,data);
          
    Stress(:,i) = data(:,5)/-90000;
     
end

for i=1:size(Stress,1)
    for j=1:size(Stress,2)
        if Stress(i,j)<0
             Stress(i,j)=0;
        end
        if i>70 & j<620
            Stress(i,j)=0;
        elseif i<23 & j>500 
            Stress(i,j) = 0;
       
        end

    end
end

i1 = 1; j1 = 1;
i2 = 1; j2 = 500;
i3 = 20; j3 = 500;

area = 0.5 * abs((i2-i1)*(j3-j1) - (i3-i1)*(j2-j1));
hang=[0];
lie=[0];
k=1

for i = 1:size(Stress, 1)
    for j = 1:size(Stress, 2)
        area1(i,j) = 0.5 * abs(det([i1, j1, 1; i2, j2, 1; i, j, 1]));
        area2(i,j) = 0.5 * abs(det([i1, j1, 1; i3, j3, 1; i, j, 1]));
        area3(i,j) = 0.5 * abs(det([i2, j2, 1; i3, j3, 1; i, j, 1]));
        
        if (area1(i,j) + area2(i,j) + area3(i,j)) == area
            Stress(i,j) = 0;
            hang=i;
            lie=j;
            pos(k,:)=[hang,lie];
            k=k+1;
        end
        
    end
end

fclose(fid);

Stress = Stress';

X(size(Stress,1),size(Stress,2)) = 0;
T(size(Stress,1),size(Stress,2)) = 0;


for i=1:size(X,1)
    X(i, :) = [1:size(X,2)].*1;
end


for i=1:size(T,2)
    T(:, i) = [1:size(T,1)].*0.02';
end

pcolor(X(:,1:80), T(:,1:80), Stress(:,1:80))
shading interp
colormap(jet)

hd = colorbar;
axis square
set(gca,'LineWidth',1,'Fontsize',20)
set(gca,'FontName','Arial')

xlabel('Position (nm)','FontName','Arial','fontsize',20)%,'fontweight','b'   
ylabel('Time (ps)','FontName','Arial','fontsize',20)

