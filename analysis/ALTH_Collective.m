% ALT-Haptic Analysis Collective Script

% data columns
id = ALTH_columns;

% FOLDERS
infolder = '/local/wessel/Experiments/ALTH/out';
outfolder = '/local/wessel/Experiments/ALTH/analysis/analysis';
clocktime = clock; hrs = num2str(clocktime(4)); mins = num2str(clocktime(5));
outfile = ['Analysis_' date '_' hrs '_' mins '_' '.mat'];

% FILES
files = dir(fullfile(infolder,'*.mat'));
filenames = {files.name};

% create overall table
RESULTS.OVERALL = zeros(length(filenames),10);

for is = 1:length(filenames)
    
    load(fullfile(infolder,filenames{is}));

    behav = ALTH_breakup(trialseq,id);
    
    % OVERALL DATA TABLE
    RESULTS.OVERALL(is,1) = behav.overall.rt.stan;
    RESULTS.OVERALL(is,2) = behav.overall.rt.nov;
    RESULTS.OVERALL(is,3) = behav.overall.rate.error.stan;
    RESULTS.OVERALL(is,4) = behav.overall.rate.error.nov; 
    RESULTS.OVERALL(is,5) = behav.overall.rate.miss.stan;
    RESULTS.OVERALL(is,6) = behav.overall.rate.miss.nov;
    RESULTS.OVERALL(is,7) = behav.overall.rate.failstop.stan;
    RESULTS.OVERALL(is,8) = behav.overall.rate.failstop.nov;
    RESULTS.OVERALL(is,9) = behav.overall.rate.succstop.stan;
    RESULTS.OVERALL(is,10) = behav.overall.rate.succstop.nov;
    
    % BLOCKWISE DATA TABLE
    blocks = 8;
    for ib = 1:blocks;
        
        eval(['RESULTS.BLOCKWISE.RT.stan(is,ib) = behav.block' num2str(ib) '.rt.stan']);
        eval(['RESULTS.BLOCKWISE.RT.nov(is,ib) = behav.block' num2str(ib) '.rt.nov']);
        eval(['RESULTS.BLOCKWISE.RATE.ERROR.stan(is,ib) = behav.block' num2str(ib) '.rate.error.stan']);
        eval(['RESULTS.BLOCKWISE.RATE.ERROR.nov(is,ib) = behav.block' num2str(ib) '.rate.error.nov']);
        eval(['RESULTS.BLOCKWISE.RATE.MISS.stan(is,ib) = behav.block' num2str(ib) '.rate.miss.stan']);
        eval(['RESULTS.BLOCKWISE.RATE.MISS.nov(is,ib) = behav.block' num2str(ib) '.rate.miss.nov']);
        eval(['RESULTS.BLOCKWISE.RATE.FAILSTOP.stan(is,ib) = behav.block' num2str(ib) '.rate.failstop.stan']);
        eval(['RESULTS.BLOCKWISE.RATE.FAILSTOP.nov(is,ib) = behav.block' num2str(ib) '.rate.failstop.nov']);
        eval(['RESULTS.BLOCKWISE.RATE.SUCCSTOP.stan(is,ib) = behav.block' num2str(ib) '.rate.succstop.stan']);
        eval(['RESULTS.BLOCKWISE.RATE.SUCCSTOP.nov(is,ib) = behav.block' num2str(ib) '.rate.succstop.nov']);
        
    end
    
end

% Give results tables mean/SE
RESULTS.OVERALL = meanSE(RESULTS.OVERALL,1);
RESULTS.BLOCKWISE.RT.stan = meanSE(RESULTS.BLOCKWISE.RT.stan,1);
RESULTS.BLOCKWISE.RT.nov = meanSE(RESULTS.BLOCKWISE.RT.nov,1);
RESULTS.BLOCKWISE.RATE.ERROR.stan = meanSE(RESULTS.BLOCKWISE.RATE.ERROR.stan,1);
RESULTS.BLOCKWISE.RATE.ERROR.nov = meanSE(RESULTS.BLOCKWISE.RATE.ERROR.nov,1);
RESULTS.BLOCKWISE.RATE.MISS.stan = meanSE(RESULTS.BLOCKWISE.RATE.MISS.stan,1);
RESULTS.BLOCKWISE.RATE.MISS.nov = meanSE(RESULTS.BLOCKWISE.RATE.MISS.nov,1);
RESULTS.BLOCKWISE.RATE.FAILSTOP.stan = meanSE(RESULTS.BLOCKWISE.RATE.FAILSTOP.stan,1);
RESULTS.BLOCKWISE.RATE.FAILSTOP.nov = meanSE(RESULTS.BLOCKWISE.RATE.FAILSTOP.nov,1);
RESULTS.BLOCKWISE.RATE.SUCCSTOP.stan = meanSE(RESULTS.BLOCKWISE.RATE.SUCCSTOP.stan,1);
RESULTS.BLOCKWISE.RATE.SUCCSTOP.nov = meanSE(RESULTS.BLOCKWISE.RATE.SUCCSTOP.nov,1);



















