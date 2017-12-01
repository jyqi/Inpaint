function [flag] = check(M, N, xmin, xmax, ymin, ymax)
    if((xmin > M * 0.8 || xmax < M * 0.2) && (ymin > N * 0.8 || ymax < N * 0.2)) 
        if((xmax - xmin) < M * 0.2 && (ymax - ymin) < N * 0.2)
            flag = 1;
        else
            flag = 0;
        end
    else
        flag = 0;
    end
        
        
end