function [wrapped_image] = wrap_image(original_image,triangle_vertices,...
    triangles, w, h1, h2)%,triangle_num, bary_coordinates)
%WRAP_IMAGE Summary of this function goes here
%   Detailed explanation goes here

neutral_w = 0;
neutral_h1 = 0;
neutral_h2 = 0;
fScale = 1;

[retVertX, retVertY] = interpVert(triangle_vertices(:,1), triangle_vertices(:,2),...
                        neutral_w, neutral_h1, neutral_h2, w, h1, h2, fScale);

%find the affine transform  matrices
Affine = zeros(3,3,size(triangles,1));
for t = 1:size(triangles,1)
     coord1 = horzcat(1,triangle_vertices(triangles(t,1),:));
     coord2 = horzcat(1,triangle_vertices(triangles(t,2),:));
     coord3 = horzcat(1,triangle_vertices(triangles(t,3),:));
     new_coord1 = horzcat(retVertX(triangles(t,1),:),retVertY(triangles(t,1),:));
     new_coord2 = horzcat(retVertX(triangles(t,2),:),retVertY(triangles(t,2),:));
     new_coord3 = horzcat(retVertX(triangles(t,3),:),retVertY(triangles(t,3),:));
     X = [coord1; coord2; coord3];
     a = inv(X) * [new_coord1(1);new_coord2(1);new_coord3(1)];
     b = inv(X) * [new_coord1(2);new_coord2(2);new_coord3(2)];
     Affine(:,:,t) = [a(2), a(3), a(1); b(2), b(3), b(1); 0, 0, 1];
end

%calculate the barycentric coordinates of all the pixels
[triangle_num, bary_coordinates] = calc_barycentric(original_image, [retVertX, retVertY], triangles);

%generate the wrapped image
wrapped_image = zeros(size(original_image));
for x = 1:size(original_image,2)
    for y = 1:size(original_image,1)
        %disp(sprintf('(%f,%f)',x,y));
        triangle = triangle_num(x,y);
        if(triangle == 0)
            %wrapped_image(y,x) = original_image(y,x);
            wrapped_image(y,x) = 0;
        else 
            new_pixel = inv(Affine(:,:,triangle)) * [x;y;1];
            new_pixel_x = new_pixel(1);
            new_pixel_y = new_pixel(2);
            %bilinear interpolation
            e = new_pixel_x - floor(new_pixel_x);
            f = new_pixel_y - floor(new_pixel_y);
            upper_left_val = (1-e).*(1-f).*original_image(floor(new_pixel_y),floor(new_pixel_x));
            upper_right_val = e.*(1-f).*original_image(floor(new_pixel_y),ceil(new_pixel_x));
            lower_left_val = (1-e).*f.*original_image(ceil(new_pixel_y),floor(new_pixel_x));
            lower_right_val = e.*f.*original_image(ceil(new_pixel_y),ceil(new_pixel_x));
            wrapped_image(y,x) = round(upper_left_val+upper_right_val+...
                lower_left_val+lower_right_val);
        end
    end
end
end

