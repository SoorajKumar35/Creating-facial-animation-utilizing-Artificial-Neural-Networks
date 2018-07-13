function[] = run(datadir)

addpath(datadir);
%We load the mesh.txt file and the image file
mouth_img = imread('mouth.jpg');
text_data = importdata('mesh.txt');
num_of_traingles_ind = 1 + 2*text_data(1) + 1;
num_of_traingles = text_data(num_of_traingles_ind);
coords = text_data(2:text_data(1)*2+1);
traingles = text_data(num_of_traingles_ind+1:end);

%Organizing coords and traingles properly
table_coords = [];
table_traingles = [];
for i=0:length(coords)-1
    row = floor(i/2); % calculates row needed
    col = rem(i,2); % can either be 1 or 0
    table_coords(row+1,col+1) = coords(i+1);
end
for i=0:length(traingles)-1
    row = floor(i/3);
    col = rem(i,3);
    table_traingles(row+1,col+1) = traingles(i+1);
end
%[triangle_num, bary_coordinates] = calc_barycentric(mouth_img, table_coords, table_traingles);
%Loading the ECE417_MP5_AV_DATA file

av_data = load('ECE417_MP5_AV_Data.mat');
%disp('hello world!');
% load('mapping.mat');
[mapping] = ECE417_MP5_train(av_data.av_train, av_data.av_validate, av_data.silenceModel,100,'mapping.mat');
[results] = ECE417_MP5_test(av_data.testAudio, av_data.silenceModel,mapping,'results.mat');
% load('results.mat');

%disp('Hello World the second');

%Image warping section
num_frames = size (av_data.testAudio,2);

image_frames = zeros(size(mouth_img,1),size(mouth_img,2),num_frames);
I = zeros(size(mouth_img,1),size(mouth_img,2),num_frames);
%disp(num_frames);
for i = 1:num_frames
    image_frames(:,:,i) = wrap_image(mouth_img,table_coords,...
        table_traingles, results(1,i), results(2,i), results(3,i));%,...
        %triangle_num, bary_coordinates);
    I = mat2gray(image_frames(:,:,i), [0 255]);
    imshow(I);
    %saveas(gcf,sprintf('DxBMP/test_%04d.jpg',i-1));
    str = sprintf('DxBMP/test_%04d.jpg',i-1);
    set(gcf,'PaperUnits','inches','PaperPosition',[0 0 1.3 0.79])
    print( '-djpeg',sprintf('DxBMP/test_%04d.bmp',i-1),'-r100');
end

v = VideoWriter('test.avi','Uncompressed AVI');
v.open();
for i = 1:num_frames
    %disp(i);
    if i <= 10
        eval('A(:,:,i) = rgb2gray(imread(''test_000' + string(i-1) + '.bmp''))'+';');
        %disp('I am here');
    elseif i <= 100
        eval('A(:,:,i) = rgb2gray(imread(''test_00' + string(i-1) + '.bmp''))'+';');
    else
        eval('A(:,:,i) = rgb2gray(imread(''test_0' + string(i-1) + '.bmp''))'+';');
    end
    writeVideo(v, A(:,:,i));

end

v.close();

end
