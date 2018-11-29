% Collect response from handle
%   Jan R Wessel 2016, www.wessellab.org
% THIS WAS EDITED FOR SPECIFIC PURPOSES WITHIN ALT
% Usage:
%   startttime = handle_response(daq, onoff, side, speed)
% Inputs:
%   daq (int) = daq number from DaqDeviceIndex
%   ms (int) = record for how long? (ms)
% Outputs:
%   RT (int) = RT in ms
%   Resp (int) = 1: left handle, 2 = right handle
%   traces (ms x 2 matrix) = raw traces from both handles
% Connectors on DAQ:
%   1: Left handle
%   2: Right handle
% Needs:
%   % DaqAInScanJRW, which is the original PTB function, edited for compatibility with R2015a; where bitcmp doesn't work
function [RT,Resp] = handle_response_ALTH(daq,ms,settings,trialseq,id,it)

% settings
DAQoptions.channel = [8 9]; % 8 = single pin A0 (#1), 9 = single pin A1 (#2)
DAQoptions.srate = 1000; % sampling rate 1000 Hz
DAQoptions.range = ones(size(DAQoptions.channel)); % default gain
DAQoptions.count = ms; % actually DAQoptions.srate/1000 * ms; but for 1000Hz this is faster
DAQoptions.ms = ms;

% begin scan
DAQoptions.begin = 1;
DAQoptions.continue = 0;
DAQoptions.end = 0;
DaqAInScanJRW(daq,DAQoptions);

% scan
DAQoptions.continue = 1; DAQoptions.begin = 0;
starttime = GetSecs;

% set flags
hdisplay = false; hoffset = false;

while GetSecs - starttime < ms/1000
    
    % acquite samples
    DaqAInScanJRW(daq,DAQoptions);
    
    % STIMULUS DISPLAY
    if GetSecs - starttime >= settings.duration.delay && ~hdisplay

        if trialseq(it,id.nov) == 1

            % vribrate handle
            vibrate_handle(settings.daq, 1, 'both', 'both'); % vibration on, vibrate both motors to begin with to account for long ramp-up time for left slow motor
            WaitSecs(.01); % Wait 10 ms, then turn off fast
            vibrate_handle(settings.daq, 1, 'both', 'slow'); % now the actual differential vibration slow / fast
            
            % set flag to true
            hdisplay = true;
            
        end
        
    end
    
    % STIMULUS OFFSET
    if GetSecs - starttime >= settings.duration.delay + settings.duration.cue
     
        % if is haptic novel
        if ~hoffset
            
            % vribrate off
            vibrate_handle(settings.daq, 0);
            
            % set flag to true
            hoffset = true;
            
        end
        
    end
    
end

% end scan
DAQoptions.continue = 0; DAQoptions.end = 1;
traces = DaqAInScanJRW(daq,DAQoptions);

% compute RT
leftr = find(traces(:,1)>1,1,'first');
rightr = find(traces(:,2)>1,1,'first');
if isempty(leftr) && isempty(rightr)
    RT = 0; Resp = 0;
elseif ~isempty(leftr) && ~isempty(rightr)
    [RT,Resp] = min([leftr rightr]);
elseif ~isempty(leftr)
    RT = leftr; Resp = 1;
elseif ~isempty(rightr)
    RT = rightr; Resp = 2;
end