% ALTH_collective

clear;clc

response = input('Would you like to print graphs?');

% data columns
id = ALTH_columns;

% Files and folders
infolder = fullfile(which('ALTH.m'),'out');
outfolder = fullfile(which('ALTH_collective.m'),'analysis');
clocktime = clock; hrs = num2str(clocktime(4)); mins = num2str(clocktime(5));
outfile = ['Analysis_' date '_' hrs '_' mins '_' '.mat'];
files = dir(fullfile(infolder,'*.mat'));
filenames = {files.name};

DATA.overall = zeros(length(filenames),10);

for is = 1:length(filenames)
    
    % load in files
    load(fullfile(infolder,filenames{is}));
    
    % perform analysis on each person
    behav = ALTH_breakup(trialseq,id);
    
    % place into overall data table
    DATA.overall(is,1) = behav.overall.rt.stan;
    DATA.overall(is,2) = behav.overall.rt.nov;
    DATA.overall(is,3) = behav.overall.rate.error.stan;
    DATA.overall(is,4) = behav.overall.rate.error.nov;
    DATA.overall(is,5) = behav.overall.rate.miss.stan;
    DATA.overall(is,6) = behav.overall.rate.miss.nov;
    DATA.overall(is,7) = behav.overall.rate.failstop.stan;
    DATA.overall(is,8) = behav.overall.rate.failstop.nov;
    DATA.overall(is,9) = behav.overall.rate.succstop.stan;
    DATA.overall(is,10) = behav.overall.rate.succstop.nov;
    
    % place blockwise data into tables
    blocks = trialseq(end,id.block);
    for ib = 1:blocks
        
        eval(['DATA.blockwise.rt.stan(is,ib) = behav.block' num2str(ib) '.rt.stan']);
        eval(['DATA.blockwise.rt.nov(is,ib) = behav.block' num2str(ib) '.rt.nov']);
        eval(['DATA.blockwise.rate.error.stan(is,ib) = behav.block' num2str(ib) '.rate.error.stan']);
        eval(['DATA.blockwise.rate.error.nov(is,ib) = behav.block' num2str(ib) '.rate.error.nov']);
        eval(['DATA.blockwise.rate.miss.stan(is,ib) = behav.block' num2str(ib) '.rate.miss.stan']);
        eval(['DATA.blockwise.rate.miss.nov(is,ib) = behav.block' num2str(ib) '.rate.miss.nov']);
        eval(['DATA.blockwise.rate.failstop.stan(is,ib) = behav.block' num2str(ib) '.rate.failstop.stan']);
        eval(['DATA.blockwise.rate.failstop.nov(is,ib) = behav.block' num2str(ib) '.rate.failstop.nov']);
        eval(['DATA.blockwise.rate.succstop.stan(is,ib) = behav.block' num2str(ib) '.rate.succstop.stan']);
        eval(['DATA.blockwise.rate.succstop.nov(is,ib) = behav.block' num2str(ib) '.rate.succstop.nov']);
        
    end
     
end

% get mean/SE data
DATA.overall = meanSE(DATA.overall,1);
DATA.blockwise.rt.stan = meanSE(DATA.blockwise.rt.stan,1);
DATA.blockwise.rt.nov = meanSE(DATA.blockwise.rt.nov,1);
DATA.blockwise.rate.error.stan = meanSE(DATA.blockwise.rate.error.stan,1);
DATA.blockwise.rate.error.nov = meanSE(DATA.blockwise.rate.error.nov,1);
DATA.blockwise.rate.miss.stan = meanSE(DATA.blockwise.rate.miss.stan,1);
DATA.blockwise.rate.miss.nov = meanSE(DATA.blockwise.rate.miss.nov,1);
DATA.blockwise.rate.failstop.stan = meanSE(DATA.blockwise.rate.failstop.stan,1);
DATA.blockwise.rate.failstop.nov = meanSE(DATA.blockwise.rate.failstop.nov,1);
DATA.blockwise.rate.succstop.stan = meanSE(DATA.blockwise.rate.succstop.stan,1);
DATA.blockwise.rate.succstop.nov = meanSE(DATA.blockwise.rate.succstop.nov,1);

% -- Overall Graph Setup -- %

rt_values = [DATA.overall(length(filenames)+1,1), DATA.overall(length(filenames)+1,2)];
errors_values = [DATA.overall(length(filenames)+1,3), DATA.overall(length(filenames)+1,4)];
miss_values = [DATA.overall(length(filenames)+1,5), DATA.overall(length(filenames)+1,6)];
failstop_values = [DATA.overall(length(filenames)+1,7), DATA.overall(length(filenames)+1,8)];
succstop_values = [DATA.overall(length(filenames)+1,9), DATA.overall(length(filenames)+1,10)];

rt_errors = [DATA.overall(length(filenames)+2,1), DATA.overall(length(filenames)+2,2)];
errors_errors = [DATA.overall(length(filenames)+2,3), DATA.overall(length(filenames)+2,4)];
miss_errors = [DATA.overall(length(filenames)+2,5), DATA.overall(length(filenames)+2,6)];
failstop_errors = [DATA.overall(length(filenames)+2,7), DATA.overall(length(filenames)+2,8)];
succstop_errors = [DATA.overall(length(filenames)+2,9), DATA.overall(length(filenames)+2,10)];


if response == 1
    
    % Graphs

    leg = {'Standard', 'Novel'};
    y_lab = 'Time (ms)';
    x_lab = '';
    
    ylimit = 650;
    tit = 'RT';
    graph_it(tit, leg, ylimit, x_lab, y_lab, rt_values, rt_errors);

    ylimit = 2;
    tit = 'Errors';
    y_lab = '%';
    graph_it(tit, leg, ylimit, x_lab, y_lab, errors_values, errors_errors);

    ylimit = 45;
    tit = 'Miss';
    graph_it(tit, leg, ylimit, x_lab, y_lab, miss_values, miss_errors);

    ylimit = 45;
    tit = 'Failstop';
    graph_it(tit, leg, ylimit, x_lab, y_lab, failstop_values, failstop_errors);

    ylimit = 85;
    tit = 'Succstop';
    graph_it(tit, leg, ylimit, x_lab, y_lab, succstop_values, succstop_errors);
    
end


% -- Blockwise Graph Setup -- %
rt_values = []; rt_errors = [];
errors_values = []; errors_errors = [];
miss_values = []; miss_errors = [];
failstop_values = []; failstop_errors = [];
succstop_values = []; succstop_errors = [];

% RT
for ib = 1:blocks
    
    rt_values = [rt_values; DATA.blockwise.rt.stan(length(filenames)+1,ib), DATA.blockwise.rt.nov(length(filenames)+1,ib)];
    rt_errors = [rt_errors; DATA.blockwise.rt.stan(length(filenames)+2,ib), DATA.blockwise.rt.nov(length(filenames)+2,ib)];
    
    errors_values = [errors_values; DATA.blockwise.rate.error.stan(length(filenames)+1,ib), DATA.blockwise.rate.error.nov(length(filenames)+1,ib)];
    errors_errors = [errors_errors; DATA.blockwise.rate.error.stan(length(filenames)+2,ib), DATA.blockwise.rate.error.nov(length(filenames)+2,ib)];
    
    miss_values = [miss_values; DATA.blockwise.rate.miss.stan(length(filenames)+1,ib), DATA.blockwise.rate.miss.nov(length(filenames)+1,ib)];
    miss_errors = [miss_errors; DATA.blockwise.rate.miss.stan(length(filenames)+2,ib), DATA.blockwise.rate.miss.nov(length(filenames)+2,ib)];
    
    failstop_values = [failstop_values; DATA.blockwise.rate.failstop.stan(length(filenames)+1,ib), DATA.blockwise.rate.failstop.nov(length(filenames)+1,ib)];
    failstop_errors = [failstop_errors; DATA.blockwise.rate.failstop.stan(length(filenames)+2,ib), DATA.blockwise.rate.failstop.nov(length(filenames)+2,ib)];
    
    succstop_values = [succstop_values; DATA.blockwise.rate.succstop.stan(length(filenames)+1,ib), DATA.blockwise.rate.succstop.nov(length(filenames)+1,ib)];
    succstop_errors = [succstop_errors; DATA.blockwise.rate.succstop.stan(length(filenames)+2,ib), DATA.blockwise.rate.succstop.nov(length(filenames)+2,ib)];
    
end

% Print graphs

if response == 1

    leg = {'Standard', 'Novel'};
    y_lab = 'Time (ms)';
    x_lab = 'Block';
    
    ylimit = 650;
    tit = 'RT';
    graph_it(tit, leg, ylimit, x_lab, y_lab, rt_values, rt_errors);

    ylimit = 3.5;
    tit = 'Errors';
    y_lab = '%';
    graph_it(tit, leg, ylimit, x_lab, y_lab, errors_values, errors_errors);

    ylimit = 45;
    tit = 'Miss';
    graph_it(tit, leg, ylimit, x_lab, y_lab, miss_values, miss_errors);

    ylimit = 50;
    tit = 'Failstop';
    graph_it(tit, leg, ylimit, x_lab, y_lab, failstop_values, failstop_errors);

    ylimit = 90;
    tit = 'Succstop';
    graph_it(tit, leg, ylimit, x_lab, y_lab, succstop_values, succstop_errors);

end


% -- ANOVA SETUP -- %

% Dependent Variables

    Y.rt = [];
    for it = 1:8
        Y.rt = [Y.rt; DATA.blockwise.rt.stan(1:length(filenames),it)];
    end
    for it = 1:8
        Y.rt = [Y.rt; DATA.blockwise.rt.nov(1:length(filenames),it)];
    end

    Y.errors = [];
    for it = 1:8
        Y.errors = [Y.errors; DATA.blockwise.rate.error.stan(1:length(filenames),it)];
    end
    for it = 1:8
        Y.errors = [Y.errors; DATA.blockwise.rate.error.nov(1:length(filenames),it)];
    end

    Y.miss = [];
    for it = 1:8
        Y.miss = [Y.miss; DATA.blockwise.rate.miss.stan(1:length(filenames),it)];
    end
    for it = 1:8
        Y.miss = [Y.miss; DATA.blockwise.rate.miss.nov(1:length(filenames),it)];
    end

    Y.failstop = [];
    for it = 1:8
        Y.failstop = [Y.failstop; DATA.blockwise.rate.failstop.stan(1:length(filenames),it)];
    end
    for it = 1:8
        Y.failstop = [Y.failstop; DATA.blockwise.rate.failstop.nov(1:length(filenames),it)];
    end
    
    Y.succstop = [];
    for it = 1:8
        Y.succstop = [Y.succstop; DATA.blockwise.rate.succstop.stan(1:length(filenames),it)];
    end
    for it = 1:8
        Y.succstop = [Y.succstop; DATA.blockwise.rate.succstop.nov(1:length(filenames),it)];
    end
    
% Preliminary setup

    %subject number
    S = [];
    sn = 1;
    it = 1;
    while it <= size(Y.rt,1)
        S = [S;sn];
        sn = sn+1;
        it = it+1;
        if sn > length(filenames)
            sn = 1;
        end
    end

    % Modality code
    F1 = zeros(size(Y.rt,1),1);
    for it = 1:2
        F1(((length(filenames)*8)*(it-1))+1:(length(filenames)*8)*it) = it;
    end

    %block code (1:8)
    F2 = [];
    for it = 1:8
        block = zeros(length(filenames),1);
        block(:,1) = it;
        F2 = [F2; block(:,1)];
    end
    F2 = repmat(F2,2,1);

    FACTNAMES = {'Modality', 'Block'};

% Plug and play

stats_rt = rm_anova2(Y.rt,S,F1,F2,FACTNAMES);
stats_error = rm_anova2(Y.errors,S,F1,F2,FACTNAMES);
stats_miss = rm_anova2(Y.miss,S,F1,F2,FACTNAMES);
stats_failstop = rm_anova2(Y.failstop,S,F1,F2,FACTNAMES);
stats_succstop = rm_anova2(Y.succstop,S,F1,F2,FACTNAMES);















