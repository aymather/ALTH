function behav = ALTH_breakup(trialseq,id)

    blocks = trialseq(end,id.block);
    for i = 1:blocks
        
        block = trialseq(trialseq(:,id.block) == i,:);
        [rate,rt] = ALTH_breakdown(block,id);
        eval(['behav.block' num2str(i) '.rt = rt']);
        eval(['behav.block' num2str(i) '.rate = rate']);
        
    end
    
    [rate,rt] = ALTH_breakdown(trialseq,id);
    behav.overall.rt = rt;
    behav.overall.rate = rate;

end

function [rate,rt] = ALTH_breakdown(trialseq,id)

    % get subtables
    gotrials = trialseq(trialseq(:,id.go) == 1,:);
    nogotrials = trialseq(trialseq(:,id.go) == 0,:);
    go_stan = gotrials(gotrials(:,id.nov) == 0,:);
    go_nov = gotrials(gotrials(:,id.nov) == 1,:);
    nogo_stan = nogotrials(nogotrials(:,id.nov) == 0,:);
    nogo_nov = nogotrials(nogotrials(:,id.nov) == 1,:);
    
    % accuracy tables
    correct_stan = go_stan(go_stan(:,id.acc) == 1,:);
    correct_nov = go_nov(go_nov(:,id.acc) == 1,:);
    error_stan = go_stan(go_stan(:,id.acc) == 2,:);
    error_nov = go_nov(go_nov(:,id.acc) == 2,:);
    miss_stan = go_stan(go_stan(:,id.acc) == 99,:);
    miss_nov = go_nov(go_nov(:,id.acc) == 99,:);
    failstop_stan = nogo_stan(nogo_stan(:,id.acc) == 3,:);
    failstop_nov = nogo_nov(nogo_nov(:,id.acc) == 3,:);
    succstop_stan = nogo_stan(nogo_stan(:,id.acc) == 4,:);
    succstop_nov = nogo_nov(nogo_nov(:,id.acc) == 4,:);
    
    % RT
    rt.stan = mean(correct_stan(:,id.rt));
    rt.nov = mean(correct_nov(:,id.rt));
    
    % error
    rate.error.stan = 100 * (size(error_stan,1) / size(go_stan,1));
    rate.error.nov = 100 * (size(error_nov,1) / size(go_nov,1));
    
    % miss
    rate.miss.stan = 100 * (size(miss_stan,1) / size(go_stan,1));
    rate.miss.nov = 100 * (size(miss_nov,1) / size(go_stan,1));
    
    % failstop
    rate.failstop.stan = 100 * (size(failstop_stan,1) / size(nogo_stan,1));
    rate.failstop.nov = 100 * (size(failstop_nov,1) / size(nogo_nov,1));
    
    % succstop
    rate.succstop.stan = 100 * (size(succstop_stan,1) / size(nogo_stan,1));
    rate.succstop.nov = 100 * (size(succstop_nov,1) / size(nogo_nov,1));

end