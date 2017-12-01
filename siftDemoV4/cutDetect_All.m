
function [cutPosition] = cutDetect_All(distA)

% model parameter
Td = 5;
w = 20; % the windows size is 2*w

cutPosition = [];
% scan the cuts
cut = 1;
Pre = [];
Fol = [];
while cut < size(distA,1)
    j = 1;
    flag = 1;
    i = cut;
    visited = zeros(size(distA, 1));
    while(1)
        if(i - flag * j <= 0) 
            if(visited(i) == 0)
                Pre = [Pre; dist(i, i + j)];
                visited(i) = 1;
                break;
            else
                flag = flag * -1;
                j = 1;
            end
        elseif(i - flag * j >= cut)
            flag = flag * -1;
            j = 1;
        elseif(visited(i) == 1)
            break;
        end
        if(distA(i - flag * j, i) > Td)
            flag = flag * -1;
            j = 1;
        else
            Pre = [Pre; distA(i - flag * j, i)];
            visited(i) = 1;
            i = i - flag * j;
            j = j * 2;
        end     
    end
    
    
    j = 1;
    flag = -1;
    i = cut;
    length = size(distA, 1);
    visited = zeros(size(distA, 1));
    while(1)
        if(i - flag * j >= length) 
            if(visited(i) == 0)
                Flo = [Flo; dist(i, i - j)];
                visited(i) = 1;
                break;
            else
                flag = flag * -1;
                j = 1;
            end
        elseif(i - flag * j <= cut)
            flag = flag * -1;
            j = 1;
        elseif(visited(i) == 1)
            break;
        end
        if(distA(i - flag * j, i) > Td)
            flag = flag * -1;
            j = 1;
        else
            Flo = [Flo; distA(i - flag * j, i)];
            visited(i) = 1;
            i = i - flag * j;
            j = j * 2;
        end     
    end
    
    % determine whether mid is big enough to be a cut
    lmean = mean(Pre(:));
    lstd = std(Pre(:));
    rmean = mean(Flo(:));
    rstd = std(Flo(:));
    if distA(cut,cut + 1)>max(lmean+Td*lstd, rmean+Td*rstd)
        cutPosition = [cutPosition;cut];        
    end
    cut = i + 1;
end

return;