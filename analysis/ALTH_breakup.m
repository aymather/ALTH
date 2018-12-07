function behav = ALTH_breakup(trialseq,id)
    
    blocks = trialseq(end,id.block);
    for it = 1:blocks
        
        blocktrials = trialseq(trialseq(:,id.block) == it,:);
        [rt,rate] = ALTH_breakdown(blocktrials,id);
        eval(['behav.block' num2str(it) '.rt = rt']);
        eval(['behav.block' num2str(it) '.rate = rate']);
        
    end
    
    [rt,rate] = ALTH_breakdown(trialseq,id);
    behav.overall.rt = rt;
    behav.overall.rate = rate;
    
end

function [rt,rate] = ALTH_breakdown(trialseq,id)
    
    % grab trials
    gotrials = trialseq(trialseq(:,id.go) == 1,:);
    nogotrials = trialseq(trialseq(:,id.go) == 0,:);
    
    % sort go/nogo by novelty
    go_stan = gotrials(gotrials(:,id.nov) == 0,:);
    go_nov = gotrials(gotrials(:,id.nov) == 1,:);
    nogo_stan = nogotrials(nogotrials(:,id.nov) == 0,:);
    nogo_nov = nogotrials(nogotrials(:,id.nov) == 1,:);
    
    % sort by accuracy
    stan_correct = go_stan(go_stan(:,id.acc) == 1,:);
    nov_correct = go_nov(go_nov(:,id.acc) == 1,:);
    
    stan_error = go_stan(go_stan(:,id.acc) == 2,:);
    nov_error = go_nov(go_nov(:,id.acc) == 2,:);
    
    stan_miss = go_stan(go_stan(:,id.acc) == 99,:);
    nov_miss = go_nov(go_nov(:,id.acc) == 99,:);
    
    stan_failstop = nogo_stan(nogo_stan(:,id.acc) == 3,:);
    nov_failstop = nogo_nov(nogo_nov(:,id.acc) == 3,:);
    
    stan_succstop = nogo_stan(nogo_stan(:,id.acc) == 4,:);
    nov_succstop = nogo_nov(nogo_nov(:,id.acc) == 4,:);
    
    % get rt's and rates
    rt.stan = mean(stan_correct(:,id.rt));
    rt.nov = mean(nov_correct(:,id.rt));
    
    rate.error.stan = 100 * (size(stan_error,1) / size(go_stan,1));
    rate.error.nov = 100 * (size(nov_error,1) / size(go_nov,1));
    rate.miss.stan = 100 * (size(stan_miss,1) / size(go_stan,1));
    rate.miss.nov = 100 * (size(nov_miss,1) / size(go_nov,1));
    rate.failstop.stan = 100 * (size(stan_failstop,1) / size(nogo_stan,1));
    rate.failstop.nov = 100 * (size(nov_failstop,1) / size(nogo_nov,1));
    rate.succstop.stan = 100 * (size(stan_succstop,1) / size(nogo_stan,1));
    rate.succstop.nov = 100 * (size(nov_succstop,1) / size(nogo_nov,1));

end