function [triangle_num, bary_coordinates] = calc_barycentric(image, triangle_vertices, triangles)
%CALC_BARYCENTRIC: Here we determine what triangle each pixel is in and its
%barycentric coordinates
triangle_num = zeros(size(image,2),size(image,1));
bary_coordinates = zeros(size(image,2),size(image,1),3);

%temp = zeros(3,size(triangles,1));
for x = 1:size(image,2)
    for y = 1:size(image,1)
        for t = 1:size(triangles,1)
            coord1 = horzcat(triangle_vertices(triangles(t,1),:),1);
            coord2 = horzcat(triangle_vertices(triangles(t,2),:),1);
            coord3 = horzcat(triangle_vertices(triangles(t,3),:),1);
            X = [coord1; coord2; coord3];
            X = X';
            temp =  inv(X) * [x;y;1];
            if(temp(1) <= 1 && temp(1) >= 0 && ...
                    temp(2) <= 1 && temp(2) >= 0 && ...
                    temp(3) <= 1 && temp(3) >= 0)
                triangle_num(x,y) = t;
                bary_coordinates(x,y,:) = temp;
            end
        end   
    end
end
    
end
