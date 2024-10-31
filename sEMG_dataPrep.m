% This code is developed by Pardis Biglarbeigi on 12 October 2024. 
% The code prepare the sEMG data based on configurations described in:

% M. A. Ozdemir, D. H. Kisa, O. Guren, A. Akan, Hand gesture classification
% using time–frequency images and transfer learning based on cnn, Biomedical 
% Signal Processing and Control 77 (2022) 103787

% The RGB images obtained from CWT encoding are saved using 7 different
% colormaps in training and testing folders, ensuring that the entries for
% train/test are exactly the same across the colormaps.




close all
clear 
clc

%% colormaps

cmap_parula = parula (256);

% %%%%%%%%%%%% BlackBody
% https://www.kennethmoreland.com/color-advice/
vec = 100 - [      100;    89;   58;  39;    0];
hex = ['#ffffff'; '#e6e635' ; '#e36905'; '#b22222' ; '#000000'];
raw = sscanf(hex','#%2x%2x%2x',[3,size(hex,1)]).' / 255;
N = 256;
cmap_BlackBody = interp1(vec,raw,linspace(100,0,N),'pchip');
cmap_BlackBody(cmap_BlackBody<10^-3) = 0;
% %%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%% Kindleman
% https://www.kennethmoreland.com/color-advice/
vec = 100 - [ 100; 90; 80; 70; 60; 50; 40; 30; 20; 10; 0 ];
hex = ['#FFFFFF'; '#FCDCC8'; '#CDCD0A'; '#61C109'; '#0FA808'; '#078942'; '#056969'; ...
    '#07458E'; '#1808A3'; '#270452'; '#000000'];
raw = sscanf(hex','#%2x%2x%2x',[3,size(hex,1)]).' / 255;
N = 256;
cmap_Kindleman = interp1(vec,raw,linspace(100,0,N),'pchip');
cmap_Kindleman(cmap_Kindleman<10^-3) = 0;
% %%%%%%%%%%%%%%%%%%%

% Crameri, F., Shephard, G.E. and Heron, P.J., 2020. The misuse of colour in 
% science communication. Nature communications, 11(1), p.5444.
% https://www.fabiocrameri.ch/colourmaps/
cmap_batlow = crameri('batlow' , 256);
% roma 
cmap_roma = crameri('roma' , 256);


% "less bad" rainbow colormap - 
% https://colorcet.com/index.html
cmap_R1 = colorcet('R1');

% unscientific Rainbow colormap
cmap_jet = jet(256);



%% calculations
% dataset obtained from:
% Ozdemir, M.A., Kisa, D.H., Guren, O. and Akan, A., 2022. Dataset for 
% multi-channel surface electromyography (sEMG) signals of hand gestures. 
% Data in brief, 41, p.107921.

% Freely available at:
% https://data.mendeley.com/datasets/ckwc76xr2z/2

% here we used the mat files for the filtered sEMG data 
path = 'sEMG-dataset/filtered/mat/';

d = dir([path, '*.mat']);
fs = 2000;
win_size = 1000;
overlap = win_size - 100;

%% rest
disp('rest ....')
restSec = 5*fs+1:9*fs;
training_path_parula =  'ColorData/Parula/training/rest/'; mkdir(training_path_parula)
testing_path_parula =  'ColorData/Parula/testing/rest/'; mkdir(testing_path_parula)

training_path_blackbody =  'ColorData/Blackbody/training/rest/'; mkdir(training_path_blackbody)
testing_path_blackbody =  'ColorData/Blackbody/testing/rest/'; mkdir(testing_path_blackbody)

training_path_kindleman =  'ColorData/Kindleman/training/rest/'; mkdir(training_path_kindleman)
testing_path_kindleman =  'ColorData/Kindleman/testing/rest/'; mkdir(testing_path_kindleman)

training_path_batlow =  'ColorData/Batlow/training/rest/'; mkdir(training_path_batlow)
testing_path_batlow =  'ColorData/Batlow/testing/rest/'; mkdir(testing_path_batlow)

training_path_r1 =  'ColorData/R1/training/rest/'; mkdir(training_path_r1)
testing_path_r1 =  'ColorData/R1/testing/rest/'; mkdir(testing_path_r1)

training_path_jet =  'ColorData/Jet/training/rest/'; mkdir(training_path_jet)
testing_path_jet =  'ColorData/Jet/testing/rest/'; mkdir(testing_path_jet)

training_path_roma =  'ColorData/Roma/training/rest/'; mkdir(training_path_roma)
testing_path_roma =  'ColorData/Roma/testing/rest/'; mkdir(testing_path_roma)

tic 
for i = 1: length(d)
    fprintf('.')
    name = d(i).name ; 
    load([path, name]);

        rest = data(restSec , :);
        y1 = buffer(rest(: , 1) ,win_size , overlap);
        y2 = buffer(rest(: , 2) , win_size , overlap);
        y3 = buffer(rest(: , 3) , win_size , overlap);
        y4 = buffer(rest(: , 4) , win_size , overlap);
        for j = 1:size(y1 , 2)
            [cc1 , ~] = cwt(y1(: , j) , fs);
            [cc2 , ~] = cwt(y2(: , j) , fs);
            [cc3 , ~] = cwt(y3(: , j) , fs);
            [cc4 , ~] = cwt(y4(: , j) , fs);
            % parula
            tiledlayout(2,2 , 'TileSpacing','tight')
            ax1 = nexttile; imagesc(abs(cc1)); 
            colormap(ax1 , cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            ax2 = nexttile; imagesc(abs(cc2)); 
            colormap(ax2, cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            ax3 = nexttile; imagesc(abs(cc3)); 
            colormap(ax3, cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            ax4 = nexttile; imagesc(abs(cc4));  
            colormap(ax4, cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            if i<=32
                exportgraphics(gcf,[training_path_parula  , sprintf('rest%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_parula  , sprintf('rest%d_%d.jpeg' ,i, j) ])
            end

            % blackbody
             colormap(ax1, cmap_BlackBody)
             colormap(ax2, cmap_BlackBody)
             colormap(ax3, cmap_BlackBody)
             colormap(ax4, cmap_BlackBody)
            if i<=32
                exportgraphics(gcf,[training_path_blackbody  , sprintf('rest%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_blackbody  , sprintf('rest%d_%d.jpeg' ,i, j) ])
            end

            % kindleman
            colormap(ax1, cmap_Kindleman)
             colormap(ax2, cmap_Kindleman)
             colormap(ax3, cmap_Kindleman)
             colormap(ax4, cmap_Kindleman)

            if i<=32
                exportgraphics(gcf,[training_path_kindleman  , sprintf('rest%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_kindleman  , sprintf('rest%d_%d.jpeg' ,i, j) ])
            end

            % batlow
            colormap(ax1, cmap_batlow)
             colormap(ax2, cmap_batlow)
             colormap(ax3, cmap_batlow)
             colormap(ax4, cmap_batlow)
            if i<=32
                exportgraphics(gcf,[training_path_batlow  , sprintf('rest%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_batlow  , sprintf('rest%d_%d.jpeg' ,i, j) ])
            end

            % r1
            colormap(ax1, cmap_R1)
             colormap(ax2, cmap_R1)
             colormap(ax3, cmap_R1)
             colormap(ax4, cmap_R1)
            if i<=32
                exportgraphics(gcf,[training_path_r1  , sprintf('rest%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_r1  , sprintf('rest%d_%d.jpeg' ,i, j)] )
            end

            % jet
            colormap(ax1, cmap_jet)
             colormap(ax2, cmap_jet)
             colormap(ax3, cmap_jet)
             colormap(ax4, cmap_jet)
            if i<=32
                exportgraphics(gcf,[training_path_jet  , sprintf('rest%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_jet  , sprintf('rest%d_%d.jpeg' ,i, j) ])
            end

            % roma
            colormap(ax1, cmap_roma)
             colormap(ax2, cmap_roma)
             colormap(ax3, cmap_roma)
             colormap(ax4, cmap_roma)
            if i<=32
                exportgraphics(gcf,[training_path_roma  , sprintf('rest%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_roma  , sprintf('rest%d_%d.jpeg' ,i, j) ])
            end
            close all
        end

end

%% extension
disp('extension...') 

extensionSec = 15*fs+1:19*fs;
training_path_parula =  'ColorData/Parula/training/extension/'; mkdir(training_path_parula)
testing_path_parula =  'ColorData/Parula/testing/extension/'; mkdir(testing_path_parula)

training_path_blackbody =  'ColorData/Blackbody/training/extension/'; mkdir(training_path_blackbody)
testing_path_blackbody =  'ColorData/Blackbody/testing/extension/'; mkdir(testing_path_blackbody)

training_path_kindleman =  'ColorData/Kindleman/training/extension/'; mkdir(training_path_kindleman)
testing_path_kindleman =  'ColorData/Kindleman/testing/extension/'; mkdir(testing_path_kindleman)

training_path_batlow =  'ColorData/Batlow/training/extension/'; mkdir(training_path_batlow)
testing_path_batlow =  'ColorData/Batlow/testing/extension/'; mkdir(testing_path_batlow)

training_path_r1 =  'ColorData/R1/training/extension/'; mkdir(training_path_r1)
testing_path_r1 =  'ColorData/R1/testing/extension/'; mkdir(testing_path_r1)

training_path_jet =  'ColorData/Jet/training/extension/'; mkdir(training_path_jet)
testing_path_jet =  'ColorData/Jet/testing/extension/'; mkdir(testing_path_jet)

training_path_roma =  'ColorData/Roma/training/extension/'; mkdir(training_path_roma)
testing_path_roma =  'ColorData/Roma/testing/extension/'; mkdir(testing_path_roma)

tic 
for i = 8: length(d)
    fprintf('.')
    name = d(i).name ; 
    load([path, name]);

        extension = data(extensionSec , :);
        y1 = buffer(extension(: , 1) ,win_size , overlap);
        y2 = buffer(extension(: , 2) , win_size , overlap);
        y3 = buffer(extension(: , 3) , win_size , overlap);
        y4 = buffer(extension(: , 4) , win_size , overlap);
        for j = 1:size(y1 , 2)
            [cc1 , ~] = cwt(y1(: , j) , fs);
            [cc2 , ~] = cwt(y2(: , j) , fs);
            [cc3 , ~] = cwt(y3(: , j) , fs);
            [cc4 , ~] = cwt(y4(: , j) , fs);
            % parula
            tiledlayout(2,2 , 'TileSpacing','tight')
            ax1 = nexttile; imagesc(abs(cc1)); 
            colormap(ax1 , cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            ax2 = nexttile; imagesc(abs(cc2)); 
            colormap(ax2, cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            ax3 = nexttile; imagesc(abs(cc3)); 
            colormap(ax3, cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            ax4 = nexttile; imagesc(abs(cc4));  
            colormap(ax4, cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            if i<=32
                exportgraphics(gcf,[training_path_parula  , sprintf('extension%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_parula  , sprintf('extension%d_%d.jpeg' ,i, j) ])
            end

            % blackbody
             colormap(ax1, cmap_BlackBody)
             colormap(ax2, cmap_BlackBody)
             colormap(ax3, cmap_BlackBody)
             colormap(ax4, cmap_BlackBody)
            if i<=32
                exportgraphics(gcf,[training_path_blackbody  , sprintf('extension%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_blackbody  , sprintf('extension%d_%d.jpeg' ,i, j) ])
            end

            % kindleman
            colormap(ax1, cmap_Kindleman)
             colormap(ax2, cmap_Kindleman)
             colormap(ax3, cmap_Kindleman)
             colormap(ax4, cmap_Kindleman)

            if i<=32
                exportgraphics(gcf,[training_path_kindleman  , sprintf('extension%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_kindleman  , sprintf('extension%d_%d.jpeg' ,i, j) ])
            end

            % batlow
            colormap(ax1, cmap_batlow)
             colormap(ax2, cmap_batlow)
             colormap(ax3, cmap_batlow)
             colormap(ax4, cmap_batlow)
            if i<=32
                exportgraphics(gcf,[training_path_batlow  , sprintf('extension%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_batlow  , sprintf('extension%d_%d.jpeg' ,i, j) ])
            end

            % r1
            colormap(ax1, cmap_R1)
             colormap(ax2, cmap_R1)
             colormap(ax3, cmap_R1)
             colormap(ax4, cmap_R1)
            if i<=32
                exportgraphics(gcf,[training_path_r1  , sprintf('extension%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_r1  , sprintf('extension%d_%d.jpeg' ,i, j)] )
            end

            % jet
            colormap(ax1, cmap_jet)
             colormap(ax2, cmap_jet)
             colormap(ax3, cmap_jet)
             colormap(ax4, cmap_jet)
            if i<=32
                exportgraphics(gcf,[training_path_jet  , sprintf('extension%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_jet  , sprintf('extension%d_%d.jpeg' ,i, j) ])
            end

            % roma
            colormap(ax1, cmap_roma)
             colormap(ax2, cmap_roma)
             colormap(ax3, cmap_roma)
             colormap(ax4, cmap_roma)
            if i<=32
                exportgraphics(gcf,[training_path_roma  , sprintf('extension%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_roma  , sprintf('extension%d_%d.jpeg' ,i, j) ])
            end
            close all
        end
end
toc


%% flexion
disp('flexion...')
flexionSec = 25*fs+1:29*fs;
training_path_parula =  'ColorData/Parula/training/flexion/'; mkdir(training_path_parula)
testing_path_parula =  'ColorData/Parula/testing/flexion/'; mkdir(testing_path_parula)

training_path_blackbody =  'ColorData/Blackbody/training/flexion/'; mkdir(training_path_blackbody)
testing_path_blackbody =  'ColorData/Blackbody/testing/flexion/'; mkdir(testing_path_blackbody)

training_path_kindleman =  'ColorData/Kindleman/training/flexion/'; mkdir(training_path_kindleman)
testing_path_kindleman =  'ColorData/Kindleman/testing/flexion/'; mkdir(testing_path_kindleman)

training_path_batlow =  'ColorData/Batlow/training/flexion/'; mkdir(training_path_batlow)
testing_path_batlow =  'ColorData/Batlow/testing/flexion/'; mkdir(testing_path_batlow)

training_path_r1 =  'ColorData/R1/training/flexion/'; mkdir(training_path_r1)
testing_path_r1 =  'ColorData/R1/testing/flexion/'; mkdir(testing_path_r1)

training_path_jet =  'ColorData/Jet/training/flexion/'; mkdir(training_path_jet)
testing_path_jet =  'ColorData/Jet/testing/flexion/'; mkdir(testing_path_jet)

training_path_roma =  'ColorData/Roma/training/flexion/'; mkdir(training_path_roma)
testing_path_roma =  'ColorData/Roma/testing/flexion/'; mkdir(testing_path_roma)

tic 
for i = 1: length(d)
    fprintf('.')
    name = d(i).name ; 
    load([path, name]);

        flexion = data(flexionSec , :);
        y1 = buffer(flexion(: , 1) ,win_size , overlap);
        y2 = buffer(flexion(: , 2) , win_size , overlap);
        y3 = buffer(flexion(: , 3) , win_size , overlap);
        y4 = buffer(flexion(: , 4) , win_size , overlap);
        for j = 1:size(y1 , 2)
            [cc1 , ~] = cwt(y1(: , j) , fs);
            [cc2 , ~] = cwt(y2(: , j) , fs);
            [cc3 , ~] = cwt(y3(: , j) , fs);
            [cc4 , ~] = cwt(y4(: , j) , fs);
            % parula
            tiledlayout(2,2 , 'TileSpacing','tight')
            ax1 = nexttile; imagesc(abs(cc1)); 
            colormap(ax1 , cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            ax2 = nexttile; imagesc(abs(cc2)); 
            colormap(ax2, cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            ax3 = nexttile; imagesc(abs(cc3)); 
            colormap(ax3, cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            ax4 = nexttile; imagesc(abs(cc4));  
            colormap(ax4, cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            if i<=32
                exportgraphics(gcf,[training_path_parula  , sprintf('flexion%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_parula  , sprintf('flexion%d_%d.jpeg' ,i, j) ])
            end
            
            % blackbody
             colormap(ax1, cmap_BlackBody)
             colormap(ax2, cmap_BlackBody)
             colormap(ax3, cmap_BlackBody)
             colormap(ax4, cmap_BlackBody)
            if i<=32
                exportgraphics(gcf,[training_path_blackbody  , sprintf('flexion%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_blackbody  , sprintf('flexion%d_%d.jpeg' ,i, j) ])
            end
            
            % kindleman
            colormap(ax1, cmap_Kindleman)
             colormap(ax2, cmap_Kindleman)
             colormap(ax3, cmap_Kindleman)
             colormap(ax4, cmap_Kindleman)
            
            if i<=32
                exportgraphics(gcf,[training_path_kindleman  , sprintf('flexion%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_kindleman  , sprintf('flexion%d_%d.jpeg' ,i, j) ])
            end
            
            % batlow
            colormap(ax1, cmap_batlow)
             colormap(ax2, cmap_batlow)
             colormap(ax3, cmap_batlow)
             colormap(ax4, cmap_batlow)
            if i<=32
                exportgraphics(gcf,[training_path_batlow  , sprintf('flexion%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_batlow  , sprintf('flexion%d_%d.jpeg' ,i, j) ])
            end
            
            % r1
            colormap(ax1, cmap_R1)
             colormap(ax2, cmap_R1)
             colormap(ax3, cmap_R1)
             colormap(ax4, cmap_R1)
            if i<=32
                exportgraphics(gcf,[training_path_r1  , sprintf('flexion%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_r1  , sprintf('flexion%d_%d.jpeg' ,i, j)] )
            end
            
            % jet
            colormap(ax1, cmap_jet)
             colormap(ax2, cmap_jet)
             colormap(ax3, cmap_jet)
             colormap(ax4, cmap_jet)
            if i<=32
                exportgraphics(gcf,[training_path_jet  , sprintf('flexion%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_jet  , sprintf('flexion%d_%d.jpeg' ,i, j) ])
            end
            
            % roma
            colormap(ax1, cmap_roma)
             colormap(ax2, cmap_roma)
             colormap(ax3, cmap_roma)
             colormap(ax4, cmap_roma)
            if i<=32
                exportgraphics(gcf,[training_path_roma  , sprintf('flexion%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_roma  , sprintf('flexion%d_%d.jpeg' ,i, j) ])
            end
            close all
        end

end
toc


%% UD
disp('UD....')
udSec = 35*fs+1:39*fs;
training_path_parula =  'ColorData/Parula/training/UD/'; mkdir(training_path_parula)
testing_path_parula =  'ColorData/Parula/testing/UD/'; mkdir(testing_path_parula)

training_path_blackbody =  'ColorData/Blackbody/training/UD/'; mkdir(training_path_blackbody)
testing_path_blackbody =  'ColorData/Blackbody/testing/UD/'; mkdir(testing_path_blackbody)

training_path_kindleman =  'ColorData/Kindleman/training/UD/'; mkdir(training_path_kindleman)
testing_path_kindleman =  'ColorData/Kindleman/testing/UD/'; mkdir(testing_path_kindleman)

training_path_batlow =  'ColorData/Batlow/training/UD/'; mkdir(training_path_batlow)
testing_path_batlow =  'ColorData/Batlow/testing/UD/'; mkdir(testing_path_batlow)

training_path_r1 =  'ColorData/R1/training/UD/'; mkdir(training_path_r1)
testing_path_r1 =  'ColorData/R1/testing/UD/'; mkdir(testing_path_r1)

training_path_jet =  'ColorData/Jet/training/UD/'; mkdir(training_path_jet)
testing_path_jet =  'ColorData/Jet/testing/UD/'; mkdir(testing_path_jet)

training_path_roma =  'ColorData/Roma/training/UD/'; mkdir(training_path_roma)
testing_path_roma =  'ColorData/Roma/testing/UD/'; mkdir(testing_path_roma)

tic 
for i = 1: length(d)
    fprintf('.')
    name = d(i).name ; 
    load([path, name]);

        UD = data(udSec , :);
        y1 = buffer(UD(: , 1) ,win_size , overlap);
        y2 = buffer(UD(: , 2) , win_size , overlap);
        y3 = buffer(UD(: , 3) , win_size , overlap);
        y4 = buffer(UD(: , 4) , win_size , overlap);
        for j = 1:size(y1 , 2)
            [cc1 , ~] = cwt(y1(: , j) , fs);
            [cc2 , ~] = cwt(y2(: , j) , fs);
            [cc3 , ~] = cwt(y3(: , j) , fs);
            [cc4 , ~] = cwt(y4(: , j) , fs);
            % parula
            tiledlayout(2,2 , 'TileSpacing','tight')
            ax1 = nexttile; imagesc(abs(cc1)); 
            colormap(ax1 , cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            ax2 = nexttile; imagesc(abs(cc2)); 
            colormap(ax2, cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            ax3 = nexttile; imagesc(abs(cc3)); 
            colormap(ax3, cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            ax4 = nexttile; imagesc(abs(cc4));  
            colormap(ax4, cmap_parula)
            set(gca, 'XTickLabel', {}, 'YTickLabel', {})
            if i<=32
                exportgraphics(gcf,[training_path_parula  , sprintf('UD%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_parula  , sprintf('UD%d_%d.jpeg' ,i, j) ])
            end
            
            % blackbody
             colormap(ax1, cmap_BlackBody)
             colormap(ax2, cmap_BlackBody)
             colormap(ax3, cmap_BlackBody)
             colormap(ax4, cmap_BlackBody)
            if i<=32
                exportgraphics(gcf,[training_path_blackbody  , sprintf('UD%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_blackbody  , sprintf('UD%d_%d.jpeg' ,i, j) ])
            end
            
            % kindleman
            colormap(ax1, cmap_Kindleman)
             colormap(ax2, cmap_Kindleman)
             colormap(ax3, cmap_Kindleman)
             colormap(ax4, cmap_Kindleman)
            
            if i<=32
                exportgraphics(gcf,[training_path_kindleman  , sprintf('UD%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_kindleman  , sprintf('UD%d_%d.jpeg' ,i, j) ])
            end
            
            % batlow
            colormap(ax1, cmap_batlow)
             colormap(ax2, cmap_batlow)
             colormap(ax3, cmap_batlow)
             colormap(ax4, cmap_batlow)
            if i<=32
                exportgraphics(gcf,[training_path_batlow  , sprintf('UD%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_batlow  , sprintf('UD%d_%d.jpeg' ,i, j) ])
            end
            
            % r1
            colormap(ax1, cmap_R1)
             colormap(ax2, cmap_R1)
             colormap(ax3, cmap_R1)
             colormap(ax4, cmap_R1)
            if i<=32
                exportgraphics(gcf,[training_path_r1  , sprintf('UD%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_r1  , sprintf('UD%d_%d.jpeg' ,i, j)] )
            end
            
            % jet
            colormap(ax1, cmap_jet)
             colormap(ax2, cmap_jet)
             colormap(ax3, cmap_jet)
             colormap(ax4, cmap_jet)
            if i<=32
                exportgraphics(gcf,[training_path_jet  , sprintf('UD%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_jet  , sprintf('UD%d_%d.jpeg' ,i, j) ])
            end
            
            % roma
            colormap(ax1, cmap_roma)
             colormap(ax2, cmap_roma)
             colormap(ax3, cmap_roma)
             colormap(ax4, cmap_roma)
            if i<=32
                exportgraphics(gcf,[training_path_roma  , sprintf('UD%d_%d.jpeg' ,i, j) ])
            else
                exportgraphics(gcf,[testing_path_roma  , sprintf('UD%d_%d.jpeg' ,i, j) ])
            end
            close all
        end

end
toc
