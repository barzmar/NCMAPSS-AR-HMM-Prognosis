%WHAT NEXT?!?!? 08/07/2025
%
%% NOW 
% - currently data selection is more or less completed: file is read and
% divided into units->flights array of structs (Value and Name fields) and
% units->cruise array of structs. Cruise is defined as (cons_min_samples) 
% consecutive samples at around max_altitude-1%. There can be multiple
% cruises in a single flight and therefore some structs are empty.
% 
% - model order estimation is completed: function for model order estimation
% is created. It calculates and plots AIC, FPE, MDL up to a given order for
% cruise intervals of the flights. Sometimes (for file "1" for example
% there is anomalous behaviour in the MDL plot)
%
% - AR healthy model estimation is done: givenan optimal value for model
% order given by previosly metioned script (inferred by user reading the
%  plots), the first num_flights with long enough cruises of the
%  first max_units. For file "7" the best order seems to be about 9-10, but
%  there is unusually high amount of variance between parameters. Perhaps
%  by taking only one unit this could be fixed.
%% NEXT
% 
% Divide data in equal sized windows for example of the same unit and then
% estimate AR Parameters (sith overlapping lag)
%
% Continue and keep writing the script according to Pradellas work: now is
% time to write ITakuro Saito function and PSDmodel funtion (take
% parameters calculated each window and calculate the frequz and PSD) after
% which apply Itakuro Saito function to calculate distance between the two
% spectrums.
%
% Consider not using an AR model but ARX model with mach number as the
% input.
