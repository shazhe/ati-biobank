firefox /vols/Data/HCP/BBUK/SMS/old/ukb6225.html &
matlab

addpath /usr/local/fsl/etc/matlab ~steve/NETWORKS/FSLNets ~steve/NETWORKS/FSLNetsPredict ~steve/matlab/glmnet ~steve/matlab/FastICA_25 ~steve/matlab/FACS
cd ~steve/hcp/BBUK
load workspace3b.mat

% we originally had 5847 subjects; those with the majority of IDPs present are 5430, indexed by "K"
% we originally had 7404 variables, after removing bad and uninteresting ones, we now have 1100
% so:
% size(vars) = 5847 7404         % vars is totally-raw original subject measures for all subjects, all measures
% size(varsdraw) = 5430 1100     % varsdraw is (going to be, below) gaussianised(vars), with cut-down subsets of subjects and measures
% and to move between these:           % (and varsd is going to be deconfounded version of varsdraw)
% varsdraw = inormal(vars(K,varskeep));  % K indexes subejcts kept, varskeep indexes variables kept; inormal is Gaussianisation

% age2=nets_demean(age).^2;
% conf=[ age age2 sex nets_demean(age).*nets_demean(sex) age2.*nets_demean(sex) ALL_IDPs(:,[12 13 18]) ];
% K=sum(isnan(NET25),2)==0; KN=sum(K);  conf=inormal(conf(K,:)); conf(isnan(conf))=0;  100*KN/N
% varsd=varsdraw;       % varsdraw after removal of confounds: age, sex, head motion, head size, etc.
% varsdDEAGED=varsdraw; % varsdDEAGED means everything except age was removed
% for i=1:size(varsd,2)
%  grot=~isnan(varsd(:,i));
%  grotconf=demean(conf(grot,:));         varsd(grot,i)=nets_normalise(varsdraw(grot,i)-grotconf*(pinv(grotconf)*varsdraw(grot,i)));
%  grotconf=demean(conf(grot,[3 6 7 8])); varsdDEAGED(grot,i)=nets_normalise(varsdraw(grot,i)-grotconf*(pinv(grotconf)*varsdraw(grot,i)));
%end

% size(ALL_IDPs) = 5847 748 % ie subjects X all IDPs except the rfMRI ones; the first 18 are: subjectID, QC measures, headsize
% you can find the 748 descriptions in file:  /vols/Data/HCP/BBUK/IMAGING/data3/group/IDPinfo.txt
% size(NETdraw) = 5430 2501 % is selected-subjects X *all* IDPs (excluding the first 18, and including all the rfMRI IDPs)
% NETdraw=inormal([ALL_IDPs(K,19:end) NODEamps25(K,:) NODEamps100(K,:) NET25(K,:) NET100(K,:)]); NETd=NETdraw; NETdDEAGED=NETdraw;
%for i=1:size(NETd,2)
%  grot=~isnan(NETdraw(:,i));
%  grotconf=demean(conf(grot,:));          NETd(grot,i)=nets_demean(NETdraw(grot,i)-grotconf*(pinv(grotconf)*NETdraw(grot,i)));
%  grotconf=demean(conf(grot,[3 6 7 8]));  NETdDEAGED(grot,i)=nets_demean(NETdraw(grot,i)-grotconf*(pinv(grotconf)*NETdraw(grot,i)));
%end

% find a variable given its BB code - for example
% 172  1160-0.0	  501759    Integer Sleep duration   =>  we want the 1160- part
SleepDurationVarIDs=nets_cellfind(varsVARS,'1160-')   % find the variable ID
vars(:,SleepDurationVarIDs)     % the raw values SUBJECTS x VARIABLES
[~,SleepDurationVarIDsINVARSKEEP,~]=intersect(varskeep,SleepDurationVarIDs);
varsdraw(:,SleepDurationVarIDsINVARSKEEP) % the Gaussianised raw variables, for just the subjects with "reasonably complete" set of IDPs
scatter( vars(K,SleepDurationVarIDs(1)) , varsdraw(:,SleepDurationVarIDsINVARSKEEP(1)))
scatter( vars(K,SleepDurationVarIDs(1)) , varsd(:,SleepDurationVarIDsINVARSKEEP(1)))

% now somehow combine across multiple visits, or choose just one.
%SleepDurationRaw=nanmean(vars(:,SleepDurationVarIDs(:)),2);  % average them
SleepDurationRaw=varsdraw(:,SleepDurationVarIDsINVARSKEEP(3));  % just take the last visit
SleepDuration=varsd(:,SleepDurationVarIDsINVARSKEEP(3));

[SLEEPvsIDPSrRAW,SLEEPvsIDPSpRAW]=corr(SleepDurationRaw,NETdraw,'rows','pairwise'); % correlation - also see robustfit for regression
[SLEEPvsIDPSr,SLEEPvsIDPSp]=corr(SleepDuration,NETd,'rows','pairwise');
plot(-log10([SLEEPvsIDPSpRAW' SLEEPvsIDPSp']))

