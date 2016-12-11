if ~exist('I')
  for i=1:384
    for j=1:384
      if length(T{i,j})>10
        I(cnt,1)=i; I(cnt,2)=j;
        cnt = cnt+1
      end
    end
  end
end

% show some hist's
figure(1); clf;
indx = randi(size(I,1), 10,1);
for i=1:length(indx)
 subplot(2,5,i)
 hist( T{I(indx(i),1), I(indx(i),2)},100 )
end

close all
Cij = zeros(384,384);
for i=1:384
 for j=1:384
  Cij(i,j) = sum(length(T{i,j}));
 end
end

num_to_keep = 384*384/2
I_censor = rand(384)>0.5

