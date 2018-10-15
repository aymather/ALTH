 % % % % % % % % % % % % % % % % % % % % % % % %  
%    ALT-H (Version 2 from ALT)                  %
%    Program Written by: Alec Mather - Sep. 2018 %
%    Professor In charge: Jan Wessel             %
%    Tools: Matlab/Psychtoolbox                  %
 % % % % % % % % % % % % % % % % % % % % % % % % 

% Clean up
clear;clc
commandwindow;

% MacOS Specific
Screen('Preference', 'SkipSyncTests', 1);

% INITIALIZE
addpath(genpath(fileparts(which('ALTH.m'))));

% DESCRIPTIVES
data = ALTH_data;

% INITIALIZE
settings = ALTH_init(data);

% TRIAL SEQUENCE
trialseq = ALTH_sequence(settings,data);

% TRIALS
trialseq = ALTH_backend(settings,trialseq,data);

Screen('CloseAll');