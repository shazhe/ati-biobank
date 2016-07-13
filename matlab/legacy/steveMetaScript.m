
addpath /usr/local/fsl/etc/matlab ~/NETWORKS/FSLNets ~/NETWORKS/FSLNetsPredict ~/matlab/glmnet ~/matlab/FastICA_25 ~/matlab/FACS
cd ~/hcp/BBUK
Nkeep=200;
get(0,'Factory'); set(0,'defaultfigurecolor',[1 1 1]);
%figure;h=gcf;set(h,'PaperPositionMode','auto');set(h,'PaperOrientation','landscape');set(h,'Position',[10 10 1200 300]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

IDPs=importdata('IMAGING/data3/group/IDPs.txt'); IDPs=IDPs.data;

po=fopen('IMAGING/sortIDs/FMRIB.txt','r');
FMRIB=textscan(po,'%d %s %s');
fclose(po);
po=fopen('IMAGING/sortIDs/CTSU.txt','r');
CTSU=textscan(po,'%d %s %s');
fclose(po);

grot=sort(IDPs(:,1));  N=length(grot);  MATCH=zeros(N,2);
for i=1:N
  grotC=find(CTSU{1}==grot(i));
  for grotI=1:length(FMRIB{2})
    if strcmp(FMRIB{2}(grotI),CTSU{2}(grotC))
      MATCH(i,1)=FMRIB{1}(grotI);  MATCH(i,2)=grot(i);  break;
    end
  end
end
MATCH(find(sum(MATCH==0,2)>0),:)=[];  N=length(MATCH); % remove empty rows
[grotI,grotJ]=setdiff(IDPs(:,1),MATCH(:,2)); IDPs(grotJ,:)=[];

ALL_IDPs=zeros(N,size(IDPs,2))/0;
for i=1:N
  j=find(IDPs(:,1)==MATCH(i,2));
  ALL_IDPs(i,:)=[MATCH(i,1) IDPs(j,2:end)];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

NM_IDs=load('IMAGING/data3/group/rfMRI_IDs');
d=25;
poop=load(sprintf('IMAGING/data3/group/IDP_rfMRI_d%d_partialcorr_v1.txt',d));
grot=zeros(N,size(poop,2)-1)/0;  for i = 1:size(poop,1), grot(find(MATCH(:,2)==NM_IDs(i)),:)=poop(i,2:end); end;
NET25=grot;
poop=load(sprintf('IMAGING/data3/group/IDP_rfMRI_d%d_NodeAmplitudes_v1.txt',d));
grot=zeros(N,size(poop,2)-1)/0;  for i = 1:size(poop,1), grot(find(MATCH(:,2)==NM_IDs(i)),:)=poop(i,2:end); end;
NODEamps25=grot;
poop=load(sprintf('IMAGING/data3/group/IDP_rfMRI_d%d_NodeSkewness_v1.txt',d));
grot=zeros(N,size(poop,2)-1)/0;  for i = 1:size(poop,1), grot(find(MATCH(:,2)==NM_IDs(i)),:)=poop(i,2:end); end;
NODEskew25=grot;
poop=load(sprintf('IMAGING/data3/group/IDP_rfMRI_d%d_NodeKurtosis_v1.txt',d));
grot=zeros(N,size(poop,2)-1)/0;  for i = 1:size(poop,1), grot(find(MATCH(:,2)==NM_IDs(i)),:)=poop(i,2:end); end;
NODEkurt25=grot;
poop=load(sprintf('IMAGING/data3/group/IDP_rfMRI_d%d_NodePAmplitudes_v1.txt',d));
grot=zeros(N,size(poop,2)-1)/0;  for i = 1:size(poop,1), grot(find(MATCH(:,2)==NM_IDs(i)),:)=poop(i,2:end); end;
NODEpamps25=grot;
poop=load(sprintf('IMAGING/data3/group/IDP_rfMRI_d%d_NodePSkewness_v1.txt',d));
grot=zeros(N,size(poop,2)-1)/0;  for i = 1:size(poop,1), grot(find(MATCH(:,2)==NM_IDs(i)),:)=poop(i,2:end); end;
NODEpskew25=grot;
poop=load(sprintf('IMAGING/data3/group/IDP_rfMRI_d%d_NodePKurtosis_v1.txt',d));
grot=zeros(N,size(poop,2)-1)/0;  for i = 1:size(poop,1), grot(find(MATCH(:,2)==NM_IDs(i)),:)=poop(i,2:end); end;
NODEpkurt25=grot;
d=100;
poop=load(sprintf('IMAGING/data3/group/IDP_rfMRI_d%d_partialcorr_v1.txt',d));
grot=zeros(N,size(poop,2)-1)/0;  for i = 1:size(poop,1), grot(find(MATCH(:,2)==NM_IDs(i)),:)=poop(i,2:end); end;
NET100=grot;
poop=load(sprintf('IMAGING/data3/group/IDP_rfMRI_d%d_NodeAmplitudes_v1.txt',d));
grot=zeros(N,size(poop,2)-1)/0;  for i = 1:size(poop,1), grot(find(MATCH(:,2)==NM_IDs(i)),:)=poop(i,2:end); end;
NODEamps100=grot;
poop=load(sprintf('IMAGING/data3/group/IDP_rfMRI_d%d_NodeSkewness_v1.txt',d));
grot=zeros(N,size(poop,2)-1)/0;  for i = 1:size(poop,1), grot(find(MATCH(:,2)==NM_IDs(i)),:)=poop(i,2:end); end;
NODEskew100=grot;
poop=load(sprintf('IMAGING/data3/group/IDP_rfMRI_d%d_NodeKurtosis_v1.txt',d));
grot=zeros(N,size(poop,2)-1)/0;  for i = 1:size(poop,1), grot(find(MATCH(:,2)==NM_IDs(i)),:)=poop(i,2:end); end;
NODEkurt100=grot;
poop=load(sprintf('IMAGING/data3/group/IDP_rfMRI_d%d_NodePAmplitudes_v1.txt',d));
grot=zeros(N,size(poop,2)-1)/0;  for i = 1:size(poop,1), grot(find(MATCH(:,2)==NM_IDs(i)),:)=poop(i,2:end); end;
NODEpamps100=grot;
poop=load(sprintf('IMAGING/data3/group/IDP_rfMRI_d%d_NodePSkewness_v1.txt',d));
grot=zeros(N,size(poop,2)-1)/0;  for i = 1:size(poop,1), grot(find(MATCH(:,2)==NM_IDs(i)),:)=poop(i,2:end); end;
NODEpskew100=grot;
poop=load(sprintf('IMAGING/data3/group/IDP_rfMRI_d%d_NodePKurtosis_v1.txt',d));
grot=zeros(N,size(poop,2)-1)/0;  for i = 1:size(poop,1), grot(find(MATCH(:,2)==NM_IDs(i)),:)=poop(i,2:end); end;
NODEpkurt100=grot;
netsOK=find(sum(isnan(NET25),2)==0);

%po=fopen(sprintf('IDPs_fmrib.txt'),'w');  for i=1:N, fprintf(po,[num2str(ALL_IDPs(i,1),'%d') ' ' num2str(ALL_IDPs(i,2:end),'%10.3e ') '\n']);end;fclose(po);
%po=fopen(sprintf('NET25_fmrib.txt'),'w'); for i=1:N, fprintf(po,[num2str(ALL_IDPs(i,1),'%d') ' ' num2str(NET25(i,:),'%10.3e ') '\n']);end;fclose(po);
%po=fopen(sprintf('NET100_fmrib.txt'),'w');for i=1:N, fprintf(po,[num2str(ALL_IDPs(i,1),'%d') ' ' num2str(NET100(i,:),'%10.3e ') '\n']);end;fclose(po);

%%% get the list of IDP sub-modalities
! cat IMAGING/data3/group/IDPinfo.txt | awk '{print $1}' > grot.txt
po=fopen(sprintf('grot.txt'),'r');  IDPnames=textscan(po,'%s');  fclose(po);  IDPnames=IDPnames{1};
j=length(IDPnames)+1;
for i=1:size(NODEamps25,2),   IDPnames{j}=sprintf('rfMRI amplitudes (ICA25 node %d)',i);   j=j+1;  end;
for i=1:size(NODEamps100,2),  IDPnames{j}=sprintf('rfMRI amplitudes (ICA100 node %d)',i);  j=j+1;  end;
for i=1:size(NET25,2),        IDPnames{j}=sprintf('rfMRI connectivity (ICA25 edge %d)',i);        j=j+1;  end;
for i=1:size(NET100,2),       IDPnames{j}=sprintf('rfMRI connectivity (ICA100 edge %d)',i);       j=j+1;  end;

%%% OK for now let's just code it by hand
IDP_modality_types(1:18)=0;      % QC
IDP_modality_types(19:43)=1;     % T1
%%%%IDP_modality_types(??????)=2;     % T2
IDP_modality_types(44:57)=3;     % SWI
IDP_modality_types(58:73)=4;     % tfMRI
IDP_modality_types(74:748)=5;    % dMRI
IDP_modality_types(749:824)=6; % rfMRI amplitudes
IDP_modality_types(825:size(IDPnames,1))=7; % rfMRI netmats

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% get full list of subjects and vars
varsSUBS=[]; varsVARS=[];
for k = [ 5488 5490 5848 5963 6034 6225 ]
  varsORIG=load(sprintf('SMS/old/ukb%d_Oct2015.txt',k));
  varsSUBS=sort(unique([varsSUBS;varsORIG(:,1)]));
  clear table;  table.idTableBy.plaintextPreceedingTable='Ukb2docs';  varsHTML=htmlTableToCell(sprintf('SMS/old/ukb%d.html',k),table);
  varsVARS=sort(unique([ varsVARS {varsHTML{3:end,2}}]));
  % [k length(varsSUBS) length(varsVARS)]
end

%%% incrementally fill out full vars matrix and headers lists, overwriting earlier versions with later ones
vars=zeros(length(varsSUBS),length(varsVARS))/0;  clear varsHeader; clear varsSource;
for k = [ 5488 5490 5848 5963 6034 6225 ]
  varsORIG=load(sprintf('SMS/ukb%d_Oct2015.txt',k));
  clear table;  table.idTableBy.plaintextPreceedingTable='Ukb2docs';  varsHTML=htmlTableToCell(sprintf('SMS/ukb%d.html',k),table);
  [~,grotSa,grotSb]=intersect(varsSUBS,varsORIG(:,1));
  [~,grotVa,grotVb]=intersect(varsVARS,{varsHTML{3:end,2}});
  vars(grotSa,grotVa)=varsORIG(grotSb,1+grotVb);
  varsHeader(grotVa')={varsHTML{2+grotVb,5}};
  varsSource(grotVa')=k;
end

%%% fill out empty descriptions (occurs for repeat visits), and insert ". " before "Uses"
for i=size(varsHeader,2):-1:1
  if prod(size(varsHeader{i}))==0
    j=i-1;
    while prod(size(varsHeader{j}))==0
      j=j-1;
    end
    varsHeader{i}=[varsHeader{j} sprintf(' visit-%d',1+i-j)];
  end
  j=regexp(varsHeader{i},'Uses');
  if prod(size(j))>0
    grot=varsHeader{i};  varsHeader{i} = [ grot(1:j-1) '. ' grot(j:end) ];
  end
end

%%% discard non-imaged subjects
varsORIG=vars; vars=zeros(N,size(varsORIG,2))/0;
for i=1:N
  j=find(MATCH(i,1)==varsSUBS);
  if prod(size(j))==1
    vars(i,:)=varsORIG(j,:);
  else
    MATCH(i,1);
  end
end

%%% identify remaining bad vars on the basis of too much missing data, etc
badvars=[];
for i=1:size(vars,2)
  Y=vars(:,i);
  if sum(abs(mod(Y(~isnan(Y)),1))) == 0  % is this an integer or categorical variable?
    Y(Y<0)=NaN;  % I *think* that in this case negative numbers should be treated as NaN
  end
  grotKEEP=~isnan(Y);
  grot=(Y(grotKEEP)-median(Y(grotKEEP))).^2; grot=max(grot/mean(grot));   grot=0;      % do we have extreme outliers?  currently ignored
  if (sum(grotKEEP)/N>0.1) & (std(Y(grotKEEP))>0) & (max(sum(nets_class_vectomat(Y(grotKEEP))))/length(Y(grotKEEP))<0.95) & (grot<100)
      % the 3rd thing above is:  is the size of the largest equal-values-group too large?
    vars(:,i)=Y;
  else
    %[i sum(grotKEEP) std(Y(grotKEEP)) max(sum(nets_class_vectomat(Y(grotKEEP))))/length(Y(grotKEEP)) grot]
    badvars=[badvars i];
  end
end
badvars=unique(badvars);  varskeep=setdiff([1:size(vars,2)],badvars);

%%% identify "bad" vars on the basis of redundancy
for i=varskeep
  for j=varskeep
    if j>i & corr(vars(:,i),vars(:,j),'rows','pairwise')>0.9999
      if sum(~isnan(vars(:,i))) > sum(~isnan(vars(:,j)))
        k=i;
      else
        k=j;
      end
      %[i j sum(~isnan(vars(:,i))) sum(~isnan(vars(:,j))) k]
      badvars=[badvars k];
    end
  end
end
badvars=unique(badvars);  varskeep=setdiff([1:size(vars,2)],badvars);

%%% create full file of variables to then edit by hand the ordered categorised lists below
%po=fopen(sprintf('SMS/AllVars.txt'),'w');
%for i=1:size(vars,2)  % or the more limited list:   for i=varskeep
%  fprintf(po,'%s %s\n',varsVARS{i},varsHeader{i});
%end
%fclose(po);

%%%%%%%%%%%%%%%%%%%% categories
% 1  age, sex
% 2  genetics
% 3  early life factors
% 10 lifestyle and environment - general
% 11 lifestyle and environment - exercise and work
% 12 lifestyle and environment - food and drink
% 13 lifestyle and environment - alcohol
% 14 lifestyle and environment - tobacco
% 20 physical measures - general
% 21 physical measures - bone density and sizes
% 22 physical measures - cardiac
% 30 blood assays
% 31 brain IDPs
% 32 cognitive phenotypes
% 50 health and medical history, health outcomes
% 99 misc, ignored

vt{1}=[31 34 22200];
vt{2}=[21000 22000:22125 22201:22325];
vt{3}=[129 130 1677 1687 1697 1737 1767 1777 1787 20022];
vt{10}=[189 2267 2277 4825 4836 6138 6142 20118 20119 20121 22501 22599 22606];
vt{11}=[1001 1011 767 777 796 806 816 826 845 864 874 884 894 904 914 924 943 971 981 991 1021 1050:10:1220 2624 2634 ...
        3426 3637 3647 6143 6162 6164 22604 22605 22607:22615 22620 22630 22631 22640:22655];
vt{12}=[1289:10:1389 1408:10:1548 2654 3680 6144 20084:20094 20098:20109 100010:10:100560 100760:10:104670];
vt{13}=[1558:10:1628 2664 3731 3859 4407 4418 4429 4440 4451 4462 5364 20095:20097 20117 100580:10:100740];
vt{14}=[1239:10:1279 2644 2867:10:2907 2926 2936 3436:10:3506 5959 6157 6158 6183 6194 20116 22506:22508];
vt{20}=[46:50 20015 1707 1717 1727 1747 1757 2306 3062 3063 3064 21001 21002 22400:22408 22427 23099:23130 23244:23289];
vt{21}=[77 78 4106 4125 4138 4143 23200:23243 23290:23320];
vt{22}=[93:95 102 4079 4080 4194 12673:12687 12697 12698 12702 21021 22420:22426];
vt{30}=[30000:10:30300];
vt{31}=[25000:25746 25761:25768];
vt{32}=[399 20016 20018 20023 20082 20129:20157 20159 20195 20196 20198 20200 20229 20230 20240 20244:20248];
vt{50}=[134:137 2178 2188 2207:10:2257 2296 2316 2335:10:2365 2415 2443:10:2473 2492 2844 2956:10:2986 3005 3079 3140 ...
        3393 3404 3414 3571 3606 3616 3627 3741 3751 3761 3773 3786 3799 3809 3894 3992 ...
        4012 4022 4041 4056 4067 4689 4700 4717 4728 4792 4803 4814 5408 5419 5430 5441 5452 5463 5474 5485 5496 5507 ...
        5518 5529 5540 5610 5832 5843 5855 5877 5890 5901 5912 5923 5934 5945 6119 6147 6148 6149 ...
        6150 6151 6152 6153 6154 6155 6159 6177 6179 6205 20001:20010 22126:22181 22502:22505 22616 22618 22619 40001:41253];
vt{99}=[21 52 53 54 120 132 757 1647 12139 12140 12141 12187 12188 12223 12224 12253 12254 12623 12624 12651 12652 ...
        12663 12664 12671 12695 12699 12700 12704 12706 12848 12851 12854 ...
        20012:20014 20024 20074 20075 20077 20078 20083 20115 20158 20201:20227 20249:20253 21003 22499 22500 ...
        22600:22603 22617 22660:22664 25747:25753 25780 40000 105010 105030];

vt_use=[ 3 10:14 20:22 30 32 ];
vt_not_use=[ 99 1 2 31 50 ];

%%% check if there are still existing vars not listed by hand
grotI=[];  for i=varskeep
  ii=varsVARS(i);  ii=ii{1};  ii(strfind(ii,'-'):end)=[];  grotI=unique([grotI str2num(ii)]);
end
grotII=[];  for i=[vt_use vt_not_use]
  grotII=unique([grotII vt{i}]);
end
setdiff(grotI,grotII)  % should be empty if we already list above all relevant vars.

%%% sanity check of any given vt (variable type)
for i=vt{32}
  j=nets_cellfind(varsVARS,sprintf('%d-',i));
  if ~isempty(j), disp( sprintf('%d %s',i,varsHeader{j(1)} ) ); end;
end

%%% identify vars of special interest
dosI=nets_cellfind(varsVARS,'53-2.0'); scan_date=vars(:,dosI); scan_date(isnan(scan_date))=2015.7;
yobI=nets_cellfind(varsVARS,'34-0.0'); mobI=nets_cellfind(varsVARS,'52-0.0'); birth_date=vars(:,yobI)+(vars(:,mobI)-0.5)/12;
age=scan_date - birth_date;
sexI=nets_cellfind(varsVARS,'31-0.0');  sex=vars(:,sexI);
badvars=[ badvars dosI yobI mobI sexI ];

%%% discard some more vars
for i=[ vt{99} vt{1} vt{2} vt{31} vt{50} ]
  j=nets_cellfind(varsVARS,sprintf('%d-',i));
  if ~isempty(j)
    %disp([i j])
    %disp( sprintf('%d %s',i,varsHeader{j(1)} ) )
    badvars=[badvars j];
  end
end
badvars=unique(badvars);  varskeep=setdiff([1:size(vars,2)],badvars);  varskeepOLD=varskeep;

varskeepNEW=[]; varskeepVT=[];
for ii=vt_use;
  for i = vt{ii}
    j=nets_cellfind(varsVARS,sprintf('%d-',i));
    for jj=j
      if ~isempty(find(varskeep==jj))
        varskeepNEW=[varskeepNEW jj];
        varskeepVT=[varskeepVT ii];
      end
    end
  end
end
varskeep=varskeepNEW;
for i=1:length(varskeep)
   disp( sprintf('%d %d %s',i,varskeepVT(i),varsHeader{varskeep(i)} ) )
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% prepare things for CCA, unicorr, etc.

age2=nets_demean(age).^2;
conf=[ age age2 sex nets_demean(age).*nets_demean(sex) age2.*nets_demean(sex) ALL_IDPs(:,[12 13 18]) ];
K=sum(isnan(NET25),2)==0; KN=sum(K);  conf=inormal(conf(K,:)); conf(isnan(conf))=0;  100*KN/N

%%% reduce netmats to top eigenvectors - actually don't, just keep everything!
NET=NET25(K,:);
  NET1=demean(NET);     NET1=NET1/std(NET1(:));
  amNET=abs(mean(NET));  NET3=demean(NET./repmat(amNET,size(NET,1),1));  NET3(:,amNET<0.1)=[]; NET3=NET3/std(NET3(:));
  %%%grot25=nets_svds([NET1 NET3],200); % or any other combination
  grot25=[NET1 NET3]; % or any other combination
NET=NET100(K,:);
  NET1=demean(NET);     NET1=NET1/std(NET1(:));
  amNET=abs(mean(NET));  NET3=demean(NET./repmat(amNET,size(NET,1),1));  NET3(:,amNET<0.1)=[]; NET3=NET3/std(NET3(:));
  %%%grot100=nets_svds([NET1 NET3],300); % or any other combination
  grot100=[NET1 NET3]; % or any other combination

%%% PCA-pre-reduce each modality-group in its own right first, then sort out missing data and do final PCA
grotUa=inormal(ALL_IDPs(K,19:73));                                                             % no pre-reduction for the smaller modalities
grot=inormal(ALL_IDPs(K,74:end)); grotK=max(isnan(grot),[],2)==0; [grotU,~,~]=nets_svds(grot(grotK,:),80); % dMRI to dimensionality 80
grotUb=zeros(sum(K),80)/0; grotUb(grotK,:)=grotU;
[grotUc,~,~]= nets_svds(inormal([NODEamps25(K,:) NODEamps100(K,:)]),20); % node amplitudes to dimensionality 20
[grotUd,~,~]= nets_svds([grot25 grot100],80); % maybe less than 100  % netmats to dimensionality 100
NETd=[grotUa grotUb grotUc grotUd];
for i=1:size(NETd,2)
  grot=~isnan(NETd(:,i)); grotconf=demean(conf(grot,:)); NETd(grot,i)=nets_demean(NETd(grot,i)-grotconf*(pinv(grotconf)*NETd(grot,i)));
end
NETdCOV=zeros(size(NETd,1));
for i=1:size(NETd,1)
  i
  for j=i:size(NETd,1)
    grot=NETd([i j],:); grot=cov(grot(:,sum(isnan(grot))==0)'); NETdCOV(i,j)=grot(1,2); NETdCOV(j,i)=grot(1,2);
  end
end
NETdCOV2=nearestSPD(NETdCOV);  corr(NETdCOV(:),NETdCOV2(:))  % scatter(NETdCOV(:),NETdCOV2(:));
[uu1,dd]=eigs(NETdCOV2,Nkeep);    [~,grot]=eig(NETdCOV2); grot=flipud(diag(grot)); 100*sum(grot(1:Nkeep))/sum(grot)   % 98.5

%%% show how well individual IDPs are represented by the Nkeep eigenvectors
clear grot; for i=1:size(NETd,2)
  Y=NETd(:,i); grotKEEP=~isnan(Y); Y=demean(Y(grotKEEP)); X=demean(uu1(grotKEEP,:)); grot(i)=100*var(X*(pinv(X)*Y)) / var(Y); i
end
figure; plot(grot);

%%% now regenerate NETd in a simpler way
NETdraw=inormal([ALL_IDPs(K,19:end) NODEamps25(K,:) NODEamps100(K,:) NET25(K,:) NET100(K,:)]); NETd=NETdraw; NETdDEAGED=NETdraw;
for i=1:size(NETd,2)
  grot=~isnan(NETdraw(:,i));
  grotconf=demean(conf(grot,:));          NETd(grot,i)=nets_demean(NETdraw(grot,i)-grotconf*(pinv(grotconf)*NETdraw(grot,i)));
  grotconf=demean(conf(grot,[3 6 7 8]));  NETdDEAGED(grot,i)=nets_demean(NETdraw(grot,i)-grotconf*(pinv(grotconf)*NETdraw(grot,i)));
end

%%% create main working vars matrix and deconfound (and get main missing-data-adjusted subject-eigenvectors)
varsdraw=inormal(vars(K,varskeep));  varsd=varsdraw; varsdDEAGED=varsdraw;
for i=1:size(varsd,2)
  grot=~isnan(varsd(:,i));
  grotconf=demean(conf(grot,:));         varsd(grot,i)=nets_normalise(varsdraw(grot,i)-grotconf*(pinv(grotconf)*varsdraw(grot,i)));
  grotconf=demean(conf(grot,[3 6 7 8])); varsdDEAGED(grot,i)=nets_normalise(varsdraw(grot,i)-grotconf*(pinv(grotconf)*varsdraw(grot,i)));
end
varsdCOV=zeros(size(varsd,1));
for i=1:size(varsd,1)
  i
  for j=i:size(varsd,1)
    grot=varsd([i j],:); grot=cov(grot(:,sum(isnan(grot))==0)'); varsdCOV(i,j)=grot(1,2); varsdCOV(j,i)=grot(1,2);
  end
end
varsdCOV2=nearestSPD(varsdCOV);  corr(varsdCOV(:),varsdCOV2(:))  % scatter(varsdCOV(:),varsdCOV2(:));
[uu2,dd]=eigs(varsdCOV2,Nkeep);    [~,grot]=eig(varsdCOV2); grot=flipud(diag(grot)); 100*sum(grot(1:Nkeep))/sum(grot)   % 98.5

%%% show how well individual SMs are represented by the Nkeep eigenvectors
clear grot; for i=1:size(varsd,2)
  Y=varsd(:,i); grotKEEP=~isnan(Y); Y=demean(Y(grotKEEP)); X=demean(uu2(grotKEEP,:)); grot(i)=100*var(X*(pinv(X)*Y)) / var(Y); i
end
figure; plot(grot);

varsALL=[NETd varsd];
varsALLraw=[NETdraw varsdraw];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% do the CCA and permutation testing
Nperm=1000;

%%% for Sleep stuff
%% uu2=SleepStuffDeconf; uu2(isnan(uu2))=0; Nperm=100;

[ccaA,ccaB,ccaR,ccaU,ccaV,grotstats]=canoncorr(uu1,uu2); ccaR=[ccaR mean(ccaR)]
ccaRp=zeros(Nperm,size(ccaR,2));
for j=1:Nperm
  j
  [ccaAr,ccaBr,ccaRp(j,1:end-1),ccaUr,ccaVr,grotstatsr]=canoncorr(uu1,uu2(randperm(size(uu2,1)),:)); ccaRp(j,end)=mean(ccaRp(j,1:end-1));
end
figure; plot([mean(ccaRp)' prctile(ccaRp,95)' prctile(ccaRp,99)' prctile(ccaRp,99.9)' ccaR'])   % final point is mean of all Nkeep R values
for i=1:size(ccaR,2);  % show corrected pvalues
  ccaRpval(i)=(1+sum(ccaRp(2:end,1)>=ccaR(i)))/Nperm;
end
ccaRpval
Ncca=sum(ccaRpval<0.05)  % number of significant CCA components
ccaRpval(1:Ncca)



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% "spatial" ICA fed from top CCA modes

%%% split-half randomly or by sex
%sexK=sex(K); grotN1=sexK==0; grotN2=sexK==1;
grotN1=1:2:KN; grotN2=2:2:KN;

% y=usv'=Ua a=U'Y (or use corr)
J=9;  ccaUV=ccaU(:,1:J)+ccaV(:,1:J);
ccaAAA=corr(ccaUV,varsALL,'rows','pairwise'); ccaAAA=0.5*log((1+ccaAAA)./(1-ccaAAA));  % OR equivalently:  ccaAAAa=ccaUV'*varsALL;
  [icaSd,icaAd,icaWd]=fastica(ccaAAA,'approach','symm','g','tanh','epsilon',1e-13,'maxNumIterations',3000,'lastEig',J);

%%% split-half ICA using the same original CCA
ccaAAAs=corr(ccaUV(grotN1,1:J),varsALL(grotN1,:),'rows','pairwise');  ccaAAAs=0.5*log((1+ccaAAAs)./(1-ccaAAAs));
  [icaSd1,icaAd1,icaWd1]=fastica(ccaAAAs,'approach','symm','g','tanh','epsilon',1e-13,'maxNumIterations',3000,'lastEig',J);
ccaAAAs=corr(ccaUV(grotN2,1:J),varsALL(grotN2,:),'rows','pairwise');  ccaAAAs=0.5*log((1+ccaAAAs)./(1-ccaAAAs));
  [icaSd2,icaAd2,icaWd2]=fastica(ccaAAAs,'approach','symm','g','tanh','epsilon',1e-13,'maxNumIterations',3000,'lastEig',J);
[icaAdb,icaSdb,icaAd1b,icaSd1b,icaAd2b,icaSd2b] = ssorder2(icaAd,icaSd,icaAd1,icaSd1,icaAd2,icaSd2);
figure; imagesc(corr([icaAdb icaAd1b icaAd2b]),[-1 1]);

%%% NFI - why isn't this working well? It's the split-half CCA that just isn't doing well
%  Npca=Nkeep; Jold=J;
%  J=12; icaSd=[icaSd; randn(J-Jold,size(icaSd,2))]; icaAd=[[icaAd randn(Jold,J-Jold)];zeros(J-Jold,J)]; Npca=50;
%%% more aggressive split-half: splitting and then doing both CCA and ICA
%[ccaA1,ccaB1,ccaR1,ccaU1,ccaV1,grotstats1]=canoncorr(uu1(grotN1,1:Npca),uu2(grotN1,1:Npca));
%  ccaUV1=ccaU1(:,1:J)+ccaV1(:,1:J); ccaAAAs=corr(ccaUV1,varsALL(grotN1,:),'rows','pairwise');  ccaAAAs1=0.5*log((1+ccaAAAs)./(1-ccaAAAs));
%  [icaSd1,icaAd1,icaWd1]=fastica(ccaAAAs1,'approach','symm','g','tanh','epsilon',1e-13,'maxNumIterations',3000,'lastEig',J);
%[ccaA2,ccaB2,ccaR2,ccaU2,ccaV2,grotstats2]=canoncorr(uu1(grotN2,1:Npca),uu2(grotN2,1:Npca));
%  ccaUV2=ccaU2(:,1:J)+ccaV2(:,1:J); ccaAAAs=corr(ccaUV2,varsALL(grotN2,:),'rows','pairwise');  ccaAAAs2=0.5*log((1+ccaAAAs)./(1-ccaAAAs));
%  [icaSd2,icaAd2,icaWd2]=fastica(ccaAAAs2,'approach','symm','g','tanh','epsilon',1e-13,'maxNumIterations',3000,'lastEig',J);
%[icaAdb,icaSdb,icaAd1b,icaSd1b,icaAd2b,icaSd2b] = ssorder2(icaAd,icaSd,icaAd1,icaSd1,icaAd2,icaSd2);
%imagesc(corr([icaAdb icaAd1b icaAd2b]),[-1 1]);
%[grotA,grotB]=ss_MatsPercVar(ccaA(1:Npca,1:Jold),ccaA1(:,1:J))
%[grotA,grotB]=ss_MatsPercVar(ccaA(1:Npca,1:Jold),ccaA2(:,1:J))


icaREV=[-1 1 -1 -1 -1 -1 1 1 1];  icaSdb=diag(icaREV)*icaSdb;  % flip signs of some components for convenience of interpretation

%%% get ICA subject weights   Y = ccaU ccaAAA = icaU icaS  =>  icaU = ccaU * ccaAAA * icaS'
%%% then for nondeconfounded Yraw = ccaUraw ccaAAA = icaUraw icaS   =>   icaUraw = Yraw icaS' (this time we can't avoid going via Yraw)
icaU=ccaUV(:,1:9) * ccaAAA * icaSdb'; % the right way
picaSd=pinv(icaSdb);  icaUbad=zeros(KN,size(picaSd,2)); icaUraw=zeros(KN,size(picaSd,2));
for i=1:size(varsALL,1)
  grot=~isnan(varsALL(i,:));    icaUbad(i,:)=varsALL(i,grot)*picaSd(grot,:);  % wrong - use icaU = ccaU * ccaAAA * icaS'
  grot=~isnan(varsALLraw(i,:)); icaUraw(i,:)=varsALLraw(i,grot)*picaSd(grot,:);
end

figure('Position',[10 10 600 400]);  set(gcf,'PaperPositionMode','auto');
imagesc(corr(conf,icaUraw,'rows','pairwise','type','Spearman'),[-.61 .61]);  % correlation of ICA components with confounds
colorbar; print(gcf,'-dpdf','ICAvsCONFS1.pdf');
figure('Position',[10 10 600 400]);  set(gcf,'PaperPositionMode','auto');
imagesc(pinv(nets_normalise(conf))*nets_normalise(icaUraw),[-.61 .61]);  % correlation of ICA components with confounds
colorbar; print(gcf,'-dpdf','ICAvsCONFS2.pdf');
figure('Position',[10 10 700 600]);  set(gcf,'PaperPositionMode','auto');
grot=(age(K)-min(age(K)))/(max(age(K))-min(age(K))); scatter(icaUraw(:,1),icaUraw(:,8),30,[grot 1-grot sex(K)]);
print(gcf,'-dpdf','ICAvsCONFS3.pdf');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% univariate correlations between IDPs and SMs

%%% are there any elements in unicorr that will be estimated from too few datapoints? No.
%unicorrN=zeros(size(NETd,2),size(varsd,2));
%for i=1:size(NETd,2)
%  i
%  grot=~isnan(NETd(:,i));
%  for j=1:size(varsd,2)
%    unicorrN(i,j)= sum((~isnan(varsd(:,j))) .* grot);
%  end
%end

[unicorrR,unicorrP]=corr(NETd,varsd,'rows','pairwise');               % Pearson
[unicorrRdeaged,unicorrPdeaged]=corr(NETdDEAGED,varsdDEAGED,'rows','pairwise');               % Pearson
[unicorrRRaw,unicorrPRaw]=corr(NETdraw,varsdraw,'rows','pairwise');   % without age (etc) deconfounding done
[unicorrRs,unicorrPs]=corr(NETd,varsd,'rows','pairwise','type','Spearman');               % Spearman slightly safer than Pearson I guess
[unicorrRsRaw,unicorrPsRaw]=corr(NETdraw,varsdraw,'rows','pairwise','type','Spearman');   % without age (etc) deconfounding done
[unicorrRn,unicorrPn]=corr(NETd,varsd(randperm(size(varsd,1)),:),'rows','pairwise'); % permutation-based null sanity check

save workspace3b

splurgh;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% posthoc playing with ICA stuff

%%% view ICA horizontal weights and then list involved IDPs / SMs in increasing order
ssplot(abs(icaSdb'));  % sign not really important for this view of ICA weights.
icaS=icaSdb;
for I=1:9    % mixture-model-based renorming/thresholding
  [grotSTATS,grotTHRESH]=ggfit(icaS(I,:),1); icaS(I,:)=(icaS(I,:)-grotSTATS.gaussian.mean)/grotSTATS.gaussian.std;
end
grot=2*t_to_p(abs(icaS),10000);  [FDR_pID,FDR_pN]=FDR(grot(:),0.05)     % Bonferroni=>4.8, FDR=>[3.7,2.89]  (ICA weight thresholds)

%icaS=SleepCorr; icaU=SleepStuffDeconf; icaUraw=SleepStuff; icaTHRESH=0.08;

icaTHRESH=2.89; % more conservative FDR option
I=1;  % select ICA component from 1:J
[~,grotI]=sort(abs(icaS(I,:)'),'descend');  icaStmp=icaS(I,:); iii={};
disp(spricaStmpintf('  ICA %% %%raw           CCA-ICA mode %d',I))
for i=1:length(grotI)
  icaStmpi=icaStmp(1,grotI(i));
  if abs(icaStmpi)>=icaTHRESH
    grot=grotI(i)-size(NETd,2); % index into varsd
    if grot>0
      ii=varsVARS(varskeep(grot)); ii=ii{1}; ii(strfind(ii,'-'):end)=[]; % find the basename of the variable descriptor
      if prod(size(intersect(ii,iii))) == 0
        grott=~isnan(varsd(:,grot));  iii=union(iii,ii);
        PERC   =100*corr(icaU(grott,I),varsd(grott,grot)).^2;
        PERCraw=100*corr(icaUraw(grott,I),varsdraw(grott,grot)).^2;
        disp(sprintf('%5.1f %2.0f %2.0f %s',icaStmpi,PERC,PERCraw,varsHeader{varskeep(grot)}));
      end
    else
      grot=grotI(i);  grott=~isnan(NETd(:,grot));
      PERC   =100*corr(icaU(grott,I),NETd(grott,grot),'rows','pairwise').^2;
      PERCraw=100*corr(icaUraw(grott,I),NETdraw(grott,grot),'rows','pairwise').^2;
      disp(sprintf('%5.1f %2.0f %2.0f   %s',icaStmpi,PERC,PERCraw,IDPnames{18+grot}));
    end
  end
end
%%% show node amps and netmats
grot=icaStmp(731:751); if max(abs(grot))>icaTHRESH
  clear fakets; fakets.DD=load('IMAGING/data3/group/rfMRI_GoodComponents_d25_v1.txt'); fakets.Nnodes=length(fakets.DD);
  nets_nodeweightpics(fakets,'IMAGING/data3/group/groupICA_d25.ica/melodic_IC.sum',grot,16,2); end;
grot=icaStmp(752:806); if max(abs(grot))>icaTHRESH
  clear fakets; fakets.DD=load('IMAGING/data3/group/rfMRI_GoodComponents_d100_v1.txt'); fakets.Nnodes=length(fakets.DD);
  nets_nodeweightpics(fakets,'IMAGING/data3/group/groupICA_d100.ica/melodic_IC.sum',grot,16,2); end;
grot=icaStmp(807:1016); if max(abs(grot))>icaTHRESH
  clear fakets; fakets.DD=load('IMAGING/data3/group/rfMRI_GoodComponents_d25_v1.txt'); fakets.Nnodes=length(fakets.DD);
  grot1=zeros(fakets.Nnodes);  grot1(triu(ones(fakets.Nnodes),1)>0)=grot';
  grotM=zeros(fakets.Nnodes);  grotM(triu(ones(fakets.Nnodes),1)>0)=nanmean(NET25); grotM=grotM+grotM';
  nets_edgepics(fakets,'IMAGING/data3/group/groupICA_d25.ica/melodic_IC.sum',grotM,grot1,24,2);
  set(gcf,'PaperPositionMode','auto','Position',[10 10 1800 900]); end;
grot=icaStmp(1017:2501); if max(abs(grot))>icaTHRESH
  clear fakets; fakets.DD=load('IMAGING/data3/group/rfMRI_GoodComponents_d100_v1.txt'); fakets.Nnodes=length(fakets.DD);
  grot1=zeros(fakets.Nnodes);  grot1(triu(ones(fakets.Nnodes),1)>0)=grot';
  grotM=zeros(fakets.Nnodes);  grotM(triu(ones(fakets.Nnodes),1)>0)=nanmean(NET100); grotM=grotM+grotM';
  nets_edgepics(fakets,'IMAGING/data3/group/groupICA_d100.ica/melodic_IC.sum',grotM,grot1,24,2);
  set(gcf,'PaperPositionMode','auto','Position',[10 10 1800 900]); end;


figure;h=gcf;set(h,'PaperPositionMode','auto');set(h,'PaperOrientation','landscape');set(h,'Position',[10 10 1200 300]); clear poop*;
grotI=unique(IDP_modality_types);  grotI=grotI(grotI>0);  grotIn=IDP_modality_types(19:end);
grotS=unique(vt_use);              grotS=grotS(grotS>0);  grotSn=varskeepVT;
for I=1:J
  j=1;  grot=icaS(I,1:size(NETd,2)+1)';
  for i=grotI
    grot2=grot;  grot2(grotIn~=i)=0;  [~,poopIm(I,j)]=max(abs(grot2));  poopI(I,j)=grot(poopIm(I,j));  j=j+1;
  end
  subplot(1,3,1); imagesc(poopI ./ repmat(max(abs(poopI),[],2),1,size(poopI,2)),[-1 1]); colorbar; axis off;
  j=1;  grot=icaS(I,size(NETd,2)+1:end)';
  for i=grotS
    grot2=grot;  grot2(grotSn~=i)=0;  [~,poopSm(I,j)]=max(abs(grot2));  poopS(I,j)=grot(poopSm(I,j));  j=j+1;
  end
  subplot(1,3,2); imagesc(poopS ./ repmat(max(abs(poopS),[],2),1,size(poopS,2)),[-1 1]); axis off;
end
subplot(1,3,3);
Disease=[Hypertension BloodPressures CholesterolMeds HighCholesterol Diabetes ...
  SleepDuration BirthWeight SymbolDigitsCorrect nanmean(GripStrength,2)];
imagesc(corr(icaUraw,[conf(:,[1 3 6 8]) Disease(K,:)],'rows','pairwise','type','Spearman'),[-.31 .31]);  colorbar;  axis off;
print(gcf,'-dpdf','ICAvsSTUFF.pdf');



[grotY,grotI]=sort(age(K));
ssplot(icaUraw(grotI,7:9));
hold on; plot([1 KN],[1 1],'k'); plot([1 KN],[2 2],'k'); plot([1 KN],[3 3],'k');



%%% vars to *INVERT* because BB used a stupid scale
% 1210-   Snoring
% 1558-   Alcohol intake frequency
% 1249-   Past tobacco smoking
% 22506-  Tobacco smoking
% 6138-   Qualifications

%%% vars that are just fucked up (non-monotonic)
% 1239-   Current tobacco smoking
% 102090- Yoghurt intake

%%% Lloyd's non-monotonic list
%100334
%100338
%100635
%100636
%100637
%100271
%100499
%100006
%100002
%100004
%100003
%100005
%100016
%100017
%100347


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% univariate correlations

figure('Position',[10 10 500 230]);  set(gcf,'PaperPositionMode','auto');
dscatter(unicorrRRaw(:),unicorrR(:));  print('-dpng','RvsRraw.png');

[FDR_pID,FDR_pN]=FDR(unicorrP(:),0.05)             % use more conservative threshold FDR_pN
[FDR_pIDRaw,FDR_pNRaw]=FDR(unicorrPRaw(:),0.05)    % use more conservative threshold FDR_pN
BONF=0.05/prod(size(unicorrP))                     % even more conservative - Bonferroni
[ sum(unicorrP(:)<FDR_pN) sum(unicorrP(:)<BONF) sum(unicorrPRaw(:)<FDR_pNRaw) sum(unicorrPRaw(:)<BONF) ]
min(abs(unicorrR(unicorrP(:)<FDR_pN)))
min(abs(unicorrR(unicorrP(:)<BONF)))
min(abs(unicorrRRaw(unicorrPRaw(:)<FDR_pNRaw)))
min(abs(unicorrRRaw(unicorrPRaw(:)<BONF)))

%%% Manhattan plot of *MAX ONLY* corr(IDPs,vars), with confounds removed
grotP=unicorrP;
grotI=unique(IDP_modality_types); grotI=grotI(grotI>0); grotM=IDP_modality_types(19:end);
figure;
%plot(7*100*sum(-log10(unicorrP)>-log10(FDR_pN))/size(unicorrP,1),'LineWidth',3,'Color',[0.9 0.9 0.9]); hold on;
for i=grotI
 plot(-log10( min(grotP(grotM==i,:))),'o'); hold on;
end
legend('T1','SWI','tfMRI','dMRI','rfMRI amplitudes','rfMRI netmats');
plot([1 size(grotP,2)],[-log10(FDR_pN) -log10(FDR_pN)],'k:','LineWidth',1);
plot([1 size(grotP,2)],[-log10(BONF) -log10(BONF)],'k:','LineWidth',1);
grot=varskeepVT-[0 varskeepVT(1:end-1)]; grot(1)=0;  % find breakpoints between variable types (VTs)
for i=find(grot>0)
  plot([i i]-0.5,[0 -log10(min(grotP(:)))],'k:','LineWidth',1);
end
%grotX=([0:20].^4)/330;  for i=grotI
%  grotPP=grotP(grotM==i,:);  plot(30+size(grotP,2)-6*log(hist(-log10(grotPP(:)),grotX)/length(grotPP(:))),grotX); hold on;
%end
%set(gcf,'PaperPositionMode','auto');  print('-dpdf',sprintf('manhattanCOG.pdf'));

%%% Manhattan plot of *MAX ONLY* corr(IDPs,vars), with confounds removed (randomised dot ordering)
grotP=unicorrP;
grotI=unique(IDP_modality_types); grotI=grotI(grotI>0); grotM=IDP_modality_types(19:end);
figure('Position',[10 10 1200 500]); grotC=get(gca, 'ColorOrder'); grot=[];
for i=grotI
  plot(-log10( min(grotP(grotM==i,:))),'o'); hold on;
  %plot(( max(unicorrR(grotM==i,:).^2)),'o'); hold on;
  grot(:,find(grotI==i))=-log10( min(grotP(grotM==i,:)))';
  %grot(:,find(grotI==i))=( max(unicorrR(grotM==i,:).^2))';
end
for i=1:size(grot,1)
  for j=randperm(6)
    plot(i,grot(i,j),'o','MarkerEdgeColor',grotC(j,:)); hold on;
  end
end
legend('T1','swMRI','tfMRI','dMRI','rfMRI amplitudes','rfMRI netmats');
plot([1 size(grotP,2)],[-log10(FDR_pN) -log10(FDR_pN)],'k:','LineWidth',1);
plot([1 size(grotP,2)],[-log10(BONF) -log10(BONF)],'k:','LineWidth',1);
grot=varskeepVT-[0 varskeepVT(1:end-1)]; grot(1)=0;  % find breakpoints between variable types (VTs)
for i=find(grot>0)
  plot([i i]-0.5,[0 -log10(min(grotP(:)))],'k:','LineWidth',1);
  %plot([i i]-0.5,[0 (max(unicorrR(:).^2))],'k:','LineWidth',1);
end
set(gcf,'PaperPositionMode','auto','PaperOrientation','landscape');  print('-dpdf',sprintf('manhattanALL.pdf'));


%%% show ALL correlations
grotP=unicorrP;
grotI=unique(IDP_modality_types); grotI=grotI(grotI>0); grotM=IDP_modality_types(19:end);
figure;
for i=grotI
  %plot(log10(-log10( min(grotP(grotM==i,:)))),'o'); hold on;
  grotY=log10(-log10( grotP(grotM==i,:))); grotY(grotY<0)=NaN;
  grotX=repmat(((i+(i<3))-2)/6+[1:size(grotP,2)],size(grotY,1),1); plot(grotX(:),grotY(:),'o'); hold on;
end
legend('T1','SWI','tfMRI','dMRI','rfMRI amplitudes','rfMRI netmats');
plot([1 size(grotP,2)],log10([-log10(FDR_pN) -log10(FDR_pN)]),'k:','LineWidth',1);
plot([1 size(grotP,2)],log10([-log10(BONF) -log10(BONF)]),'k:','LineWidth',1);
grot=varskeepVT-[0 varskeepVT(1:end-1)]; grot(1)=0;  % find breakpoints between variable types (VTs)
for i=find(grot>0)
  plot([i i]-0.5,[0 log10(-log10(min(grotP(:))))],'k:','LineWidth',1);
end


%%% show ALL correlations for just cognitive
grotP=unicorrP;
grotI=unique(IDP_modality_types); grotI=grotI(grotI>0); grotM=IDP_modality_types(19:end);
figure('Position',[10 10 1200 200]); grotC=get(gca, 'ColorOrder');
j=32; % select cognitive
for i=grotI
  grotY=log10(-log10( unicorrPdeaged(grotM==i,varskeepVT==j))); grotY(grotY<0)=NaN; grotYn=size(grotY,2);
    grotX=repmat(grotYn*(i+(i<3)-2)+[1:grotYn],size(grotY,1),1);
    plot(grotX(:),grotY(:),'o','MarkerEdgeColor',[0.85 0.85 0.85]); hold on;
  grotY=log10(-log10( grotP(grotM==i,varskeepVT==j))); grotY(grotY<0)=NaN; grotYn=size(grotY,2);
    grotX=repmat(grotYn*(i+(i<3)-2)+[1:grotYn],size(grotY,1),1);
    plot(grotX(:),grotY(:),'o','MarkerEdgeColor',grotC(find(grotI==i),:)); hold on;
end
%legend('T1','swMRI','tfMRI','dMRI','rfMRI amplitudes','rfMRI netmats');
plot([1 size(grotP,2)],log10([-log10(FDR_pN) -log10(FDR_pN)]),'k:','LineWidth',1);
plot([1 size(grotP,2)],log10([-log10(BONF) -log10(BONF)]),'k:','LineWidth',1);
set(gcf,'PaperPositionMode','auto','PaperOrientation','landscape');  print('-dpdf',sprintf('manhattanCOG.pdf'));

%%% get list of strongest cognitive associations
for i=1:size(unicorrP,1),  for j=1:size(unicorrP,2)
  if varskeepVT(j)==32 & unicorrP(i,j)<BONF
    grot_r1 = 0.5*log((1+unicorrR(i,j))/(1-unicorrR(i,j)));  grot_r2 = 0.5*log((1+unicorrRdeaged(i,j))/(1-unicorrRdeaged(i,j)));
    grot_n = sum(~isnan(NETd(:,i).*varsd(:,j)));  grot_z = (grot_r1-grot_r2)/sqrt(1/(grot_n-3)+1/(grot_n-3));  grot_p = (1-normcdf(abs(grot_z),0,1))*2;
    grot_r1a=corr(NETd(bpPAIRS(:,1),i),varsd(bpPAIRS(:,1),j),'rows','pairwise');
    grot_r2a=corr(NETd(bpPAIRS(:,2),i),varsd(bpPAIRS(:,2),j),'rows','pairwise');
    grot_r1a = 0.5*log((1+grot_r1a)/(1-grot_r1a));  grot_r2a = 0.5*log((1+grot_r2a)/(1-grot_r2a));
    grot_n1a = sum(~isnan(NETd(bpPAIRS(:,1),i).*varsd(bpPAIRS(:,1),j)));  grot_n2a = sum(~isnan(NETd(bpPAIRS(:,2),i).*varsd(bpPAIRS(:,2),j)));
    grot_za = (grot_r1a-grot_r2a)/sqrt(1/(grot_n1a-3)+1/(grot_n2a-3));  grot_pa = (1-normcdf(abs(grot_za),0,1))*2;
    disp(sprintf('%d %d %.2f %.2f %d %f %.2f %.2f %f %s %s',i,j,unicorrR(i,j),unicorrRdeaged(i,j),grot_n,grot_p,grot_r1a,grot_n1a,grot_pa, ...
          IDPnames{18+i},varsHeader{varskeep(j)}));
  end
end;  end;


%%% separate plot for each IDP type
grotP=unicorrP;  grotI=unique(IDP_modality_types); grotI=grotI(grotI>0); grotM=IDP_modality_types(19:end); grotBINSoverFDR=0;
for i=grotI
  figure('Position',[10 10 500 300]); jj=1;
  for j=vt_use;
    grotB=grotP(grotM==i,varskeepVT==j)<FDR_pN; grotBINSoverFDR=grotBINSoverFDR+max(grotB(:));
    %plot(find(varskeepVT==j),-log10( min(grotP(grotM==i,varskeepVT==j))),'o'); hold on;  % just show the max
    %grotY=(unicorrR(grotM==i,varskeepVT==j).^2); grotX=repmat(find(varskeepVT==j),size(grotY,1),1); plot(grotX(:),grotY(:),'o'); hold on;
    grotY=-log10(grotP(grotM==i,varskeepVT==j)); grotX=repmat(find(varskeepVT==j),size(grotY,1),1); plot(grotX(:),grotY(:),'o'); hold on;
    grotXY(i,jj)=sum(grotY(:)>-log10(FDR_pN)); jj=jj+1;
  end
  plot([1 size(grotP,2)],[-log10(FDR_pN) -log10(FDR_pN)],'k:','LineWidth',1);
  plot([1 size(grotP,2)],[-log10(BONF) -log10(BONF)],'k:','LineWidth',1);
  grot=varskeepVT-[0 varskeepVT(1:end-1)]; grot(1)=0;  % find breakpoints between variable types (VTs)
  for I=find(grot>0)
    plot([I I]-0.5,[0 5-log10(min(min(grotP(grotM==i,:))))],'k:','LineWidth',1);
  end
  set(gcf,'PaperPositionMode','auto');  print('-dpng',sprintf('manhattanMODALITY%d.png',i));
  %%% what does the mapping from p to r look like?
  %grotP=-log10(unicorrP(grotM==i,:));grotR=unicorrR(grotM==i,:).^2;figure;scatter(grotP(:),grotR(:));
  grotR=unicorrR.^2;  grotR(grotM~=i,:)=0;  grotRmax=max(grotR(:));  [ii,jj]=find(grotR==grotRmax);
  disp(sprintf('Maximum r2 = %.3f (association of %s with %s)',grotRmax,IDPnames{18+ii},varsHeader{varskeep(jj)}));
end

imagesc(-log10(unicorrP))
plot(100*sum(-log10(unicorrP)>-log10(FDR_pN))/size(unicorrP,1))
plot(100*sum(-log10(unicorrP)>-log10(FDR_pN),2)/size(unicorrP,2))

% play with example strong result
for i = [4 15 122 132 134 150 151 152 534 536 552 562 564 565 935 940 1004 1005]
  [grotP,grotI]=sort(unicorrP(:,i));
  disp(sprintf('%.2f %.2e %.2f %.2e   %s   %s',unicorrR(grotI(1),i),unicorrP(grotI(1),i)*prod(size(unicorrP)), ...
          unicorrRdeaged(grotI(1),i),unicorrPdeaged(grotI(1),i)*prod(size(unicorrP)), ...
          varsHeader{varskeep(i)}, IDPnames{18+grotI(1)}));
end
figure; subplot(1,2,1); scatter(NETd(:,grotI(1)),varsd(:,i));
subplot(1,2,2); scatter(NETdDEAGED(:,grotI(1)),varsdDEAGED(:,i));
poop=robustfit(nets_normalise([varsdraw(:,i) conf]),nets_normalise(NETdraw(:,grotI(1))))'

%%% find var that should be highly predictable
[poopR,poopI]=sort(sum(unicorrR.^2));
[poopR,poopI]=sort(sum(-log10(unicorrP)));
for i=1:length(poopI)
  disp(sprintf('%d %f %s',varskeep(poopI(i)),poopR(i),varsHeader{varskeep(poopI(i))}));
end
[poopR,poopI]=sort(sum(-log10(unicorrPs')));
for i=1:length(poopI)
  disp(sprintf('%d %f %s',poopI(i),poopR(i),IDPnames{18+poopI(i)}));
end


%%% simulation: how does P (and number of tests allowed) vary as function of Nsubjects, for (eg) r=0.1 ?
clear grotI grotP; i=10
while i<10000
  grotI(j)=i;  grotP(j)=t_to_p(r_to_t_to_z(0.1,i),100000); % r to p conversion for r=0.1
  j=j+1; i=ceil(i*1.01);
end
subplot(1,3,1); plot(grotI,grotP);
subplot(1,3,2); plot(log10(grotI),-log10(grotP));
subplot(1,3,3); plot(grotI,log10(0.05./grotP));   % how many tests does Bonferroni allow to pass?


%%% THINK OF THE DISEASE !

Snoring=vars(:,nets_cellfind(varsVARS,'1210-')); Snoring=2-Snoring(:,3);
DayNap=vars(:,nets_cellfind(varsVARS,'1190-')); DayNap=DayNap(:,3);
DaytimeDozing=vars(:,nets_cellfind(varsVARS,'1220-')); DaytimeDozing=DaytimeDozing(:,3);
%%DaytimeDozing=max(vars(:,nets_cellfind(varsVARS,'1220-'))==1,[],2);
Sleeplessness=vars(:,nets_cellfind(varsVARS,'1200-')); Sleeplessness=Sleeplessness(:,3);
SleepDuration=vars(:,nets_cellfind(varsVARS,'1160-')); SleepDuration=SleepDuration(:,3);
SleepMorning=vars(:,nets_cellfind(varsVARS,'1170-')); SleepMorning=SleepMorning(:,3);
SleepChronotype=vars(:,nets_cellfind(varsVARS,'1180-')); SleepChronotype=SleepChronotype(:,3);

CholesterolMeds=vars(:,nets_cellfind(varsVARS,'6177-0.0'))==1;
CorpuscularVolume=nanmean(vars(:,nets_cellfind(varsVARS,'30040-')),2);
BirthWeight=nanmean(vars(:,nets_cellfind(varsVARS,'20022-')),2);
SymbolDigitsCorrect=vars(:,nets_cellfind(varsVARS,'20159-'));
GripStrength=vars(:,[nets_cellfind(varsVARS,'46-') nets_cellfind(varsVARS,'47-')]);

j=nets_cellfind(varsVARS,'20002-') % Data-coding 6: 1065 hypertension, 1111 asthma, 1387 allergies, 1473 high cholesterol, 1223 diabetes type2
Hypertension=max(vars(:,j)==1065,[],2);
Asthma=max(vars(:,j)==1111,[],2);
Allergies=max(vars(:,j)==1387,[],2);
Diabetes=max(vars(:,j)==1223,[],2);
HighCholesterol=max(vars(:,j)==1473,[],2);
BloodPressures=vars(:,[nets_cellfind(varsVARS,'4079-0.0') nets_cellfind(varsVARS,'4080-0.0')]);
HeadBMD=vars(:,nets_cellfind(varsVARS,'23226-'));

Disease=[Hypertension BloodPressures CholesterolMeds HighCholesterol Diabetes Allergies Asthma ...
  DaytimeDozing Sleeplessness SleepDuration CorpuscularVolume BirthWeight HeadBMD SymbolDigitsCorrect GripStrength];
  % OR
Disease=[Hypertension BloodPressures CholesterolMeds HighCholesterol Diabetes ...
  DaytimeDozing SleepDuration BirthWeight SymbolDigitsCorrect nanmean(GripStrength,2)];

DiseaseDeconf=Disease(K,:);
for i=1:size(DiseaseDeconf,2)
  grot=~isnan(DiseaseDeconf(:,i)); grotconf=demean(conf(grot,:));
  DiseaseDeconf(grot,i)=nets_demean(DiseaseDeconf(grot,i)-grotconf*(pinv(grotconf)*DiseaseDeconf(grot,i)));
end

%%% correlate with ICA subject modes. first 3 rows ask if Hypertension correlates more strongly than blood pressure
figure('Position',[10 10 600 450]);  set(gcf,'PaperPositionMode','auto');
imagesc(corr(DiseaseDeconf,icaU,'rows','pairwise'),[-.25 .25]);
colorbar; %print(gcf,'-dpdf','ICAvsDISEASE1.pdf');
figure('Position',[10 10 600 450]);  set(gcf,'PaperPositionMode','auto');
imagesc(corr(Disease(K,:),icaUraw,'rows','pairwise'),[-.25 .25]);
colorbar; %print(gcf,'-dpdf','ICAvsDISEASE2.pdf');


%%% compare correlations with vs without deconfounding
grot1=corr(Disease(K,:),NETdraw,'rows','pairwise');
grot2=corr(Disease(K,:),NETd,'rows','pairwise');
grot3=corr(DiseaseDeconf,NETd,'rows','pairwise');
i=1; plot([grot1(i,:)' grot2(i,:)' grot3(i,:)']);

%%% show BMD and cogtest scatterplots with vs without deconfounding
i=13;scatter(grot1(i,:)',grot3(i,:)'); hold on;
i=14;scatter(grot1(i,:)',grot3(i,:)');

figure; grot=corr([ conf Hypertension(K) ALL_IDPs(K,18+3) ], 'rows','pairwise');
subplot(1,2,1);imagesc(grot,[-.5 .5]);
subplot(1,2,2); imagesc(-inv(grot),[-.5 .5]);

%%% cool example of Berkson: HeadBMD and IDP_T1_FIRST_brain_stem+4th_ventricle_volume must drive head size
figure;subplot(1,3,1);imagesc((corr([ conf HeadBMD(K) ALL_IDPs(K,18+25) ], 'rows','pairwise')),[-.5 .5]);
subplot(1,3,2); imagesc(-inv(corr([ conf HeadBMD(K) ALL_IDPs(K,18+25) ], 'rows','pairwise')),[-.5 .5]);
subplot(1,3,3); imagesc(-inv(corr([ conf(:,8) HeadBMD(K) ALL_IDPs(K,18+25) ], 'rows','pairwise')),[-.5 .5]);

KS=sex(K)==1;
figure;subplot(1,3,1);imagesc((corr([ conf(KS,:) HeadBMD(KS) ALL_IDPs(KS,18+10) ], 'rows','pairwise')),[-.5 .5]);
subplot(1,3,2); imagesc(-inv(corr([ conf(KS,:)   HeadBMD(KS) ALL_IDPs(KS,18+10) ], 'rows','pairwise')),[-.5 .5]);
subplot(1,3,3); imagesc(-inv(corr([ conf(KS,8)   HeadBMD(KS) ALL_IDPs(KS,18+10) ], 'rows','pairwise')),[-.5 .5]);

figure;subplot(1,3,1);imagesc((corr([ conf HeadBMD(K) ALL_IDPs(K,18+2) ], 'rows','pairwise')),[-.5 .5]);
subplot(1,3,2); imagesc(-inv(corr([ conf HeadBMD(K) ALL_IDPs(K,18+2) ], 'rows','pairwise')),[-.5 .5]);
subplot(1,3,3); imagesc(-inv(corr([ conf(:,1) HeadBMD(K) ALL_IDPs(K,18+2) ], 'rows','pairwise')),[-.5 .5]);

figure;
grot=corr([conf(:,[1 8]) HeadBMD(K) ALL_IDPs(K,18+[2])] , 'rows','pairwise');
subplot(2,2,1);imagesc(grot,[-.5 .5]);
subplot(2,2,2); imagesc(-inv(grot),[-.5 .5]);
grot=corr([conf(:,[1 8]) HeadBMD(K) ALL_IDPs(K,18+[25])] , 'rows','pairwise');
subplot(2,2,3);imagesc(grot,[-.5 .5]);
subplot(2,2,4); imagesc(-inv(grot),[-.5 .5]);

%%% output for Tetrad
grot=[conf(:,[1 8]) HeadBMD(K) ALL_IDPs(K,18+[2 25])]; grot=grot( sum(isnan(grot),2)==0  ,:);
! echo " age headsize BMD periph_greyvol_unnormalised brain_stem+ventricle_volume " > grot.txt
save('grot','grot','-ascii');
! cat grot >> grot.txt ; tar cvfz ~/grot grot.txt



%%% Simpson's paradox
grot= unicorrR .* -unicorrRRaw; imagesc(grot,[-.04 .04]);
i=8; j=659; [IDPnames(18+i) varsHeader(varskeep(j))]
corr(ALL_IDPs(sex==0,i+18),vars(sex==0,varskeep(j)),'rows','pairwise')
corr(ALL_IDPs(sex==1,i+18),vars(sex==1,varskeep(j)),'rows','pairwise')
corr(ALL_IDPs(:,i+18),vars(:,varskeep(j)),'rows','pairwise')
corr(NETd(sex(K)==0,i),varsd(sex(K)==0,j),'rows','pairwise')
corr(NETd(sex(K)==1,i),varsd(sex(K)==1,j),'rows','pairwise')
corr(NETd(:,i),varsd(:,j),'rows','pairwise')
figure('Position',[10 10 950 400]);  set(gcf,'PaperPositionMode','auto');
subplot(1,2,1); scatter(ALL_IDPs(sex==0,i+18),vars(sex==0,varskeep(j)),'.');hold on; scatter(ALL_IDPs(sex==1,i+18),vars(sex==1,varskeep(j)),'.');
subplot(1,2,2); scatter(NETd(sex(K)==0,i),varsd(sex(K)==0,j),'.');hold on; scatter(NETd(sex(K)==1,i),varsd(sex(K)==1,j),'.');
print(gcf,'-dpdf','simpson.pdf');


Grip=nanmean(GripStrength(K,:),2);  GripDeconf=Grip;
for i=1:size(GripDeconf,2)
  grot=~isnan(GripDeconf(:,i)); grotconf=demean(conf(grot,[3 6 7 8]));
  GripDeconf(grot,i)=nets_demean(GripDeconf(grot,i)-grotconf*(pinv(grotconf)*DiseaseDeconf(grot,i)));
end
grot1=corr(Grip,NETdraw,'rows','pairwise');
grot2=corr(GripDeconf,NETdDEAGED,'rows','pairwise');
grot3=corr(GripDeconf.*nets_normalise(-age(K)),NETdDEAGED,'rows','pairwise');

clear poop*;
for i=1:size(NETdraw,2)
  i
  [grot1,grot2]=robustfit(nets_normalise([Grip nets_normalise(Grip).*nets_normalise(age(K)) conf]), NETdraw(:,i));
  poopT(:,i)=grot2.t;  poopP(:,i)=grot2.p;
end



SleepStuff=[Snoring DayNap DaytimeDozing Sleeplessness SleepDuration SleepMorning SleepChronotype];
SleepStuff=inormal(SleepStuff(K,:)); SleepStuffDeconf=SleepStuff;
for i=1:size(SleepStuffDeconf,2)
  grot=~isnan(SleepStuffDeconf(:,i)); grotconf=demean(conf(grot,:));
  SleepStuffDeconf(grot,i)=nets_demean(SleepStuffDeconf(grot,i)-grotconf*(pinv(grotconf)*SleepStuffDeconf(grot,i)));
end
figure; imagesc(corr(SleepStuffDeconf,icaU,'rows','pairwise'),[-.2 .2]); colorbar;
figure; imagesc(corr(SleepStuff,icaUraw,'rows','pairwise'),[-.2 .2]); colorbar;
[SleepCorrRawR,SleepCorrRawP]=corr(SleepStuff,NETdraw,'rows','pairwise');
[SleepCorrR,SleepCorrP]=corr(SleepStuffDeconf,NETd,'rows','pairwise');
plot(-log10([SleepCorrRawP(:,5) SleepCorrP(:,5)]));
SleepBonf=0.05/prod(size(SleepCorrRawP))
-log10(SleepBonf)




%%% test whether subtracting any two cognitive measures correlates more strongly with IDPs....not v much.
for i=varskeep(varskeepVT==32);
  disp(sprintf('%d %s %s',i,varsVARS{i},varsHeader{i}));
end
grot=[];
for i=[399 20016 20018 20023 20082 20132 20156 20157 20159 20195 20240 20247 20248]
  grot=[grot nets_cellfind(varsVARS,sprintf('%d-',i))];
end
[~,grot2]=intersect(varskeep,grot);
grot=varsd(:,grot2); grotI=zeros(1,length(grot2))/0; grotJ=grotI;
for i=1:length(grot2)
  for j=i+1:length(grot2)
    grot=[grot grot(:,i)-grot(:,j)]; grotI=[grotI i]; grotJ=[grotJ j];
  end
end
grott=corr(grot,icaU,'rows','pairwise'); plot(grott);
i=101; varsHeader(varskeep(grot2([grotI(i) grotJ(i)])))'

[unicorrRg,unicorrPg]=corr(NETd,grot,'rows','pairwise');
i=267; varsHeader(varskeep(grot2([grotI(i) grotJ(i)])))'  % a VERY strong result.....weird!
%    'Duration of questionnaire'
%    'Total errors traversing numeric path (trail #1)'



%%% investigate Head Bone mineral density correlations - interaction with deconfounding
j=nets_cellfind(varsVARS,'23226-');  jj=find(varskeep==j);  HeadBMD=vars(:,j);
[unicorrRs1,unicorrPs1]=corr(NETd,varsd(:,jj),'rows','pairwise','type','Spearman');
[unicorrRs2,unicorrPs2]=corr(NETd,HeadBMD(K),'rows','pairwise','type','Spearman');
[unicorrRs3,unicorrPs3]=corr(NETdraw,HeadBMD(K),'rows','pairwise','type','Spearman');
scatter(unicorrRs1,unicorrRs3); hold on; scatter(unicorrRs1,unicorrRs2); scatter(unicorrRs2,unicorrRs3);
plot([unicorrRs1 unicorrRs2 unicorrRs3]);
IDPnames([1:25]+18)
for i=1:25
  grot=robustfit(HeadBMD(K),NETd(:,i));    unicorrRs4(i)=grot(2);
  grot=robustfit(HeadBMD(K),NETdraw(:,i)); unicorrRs5(i)=grot(2);
end
plot([unicorrRs2(1:25) unicorrRs3(1:25) .5*unicorrRs4' .5*unicorrRs5']);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% multivariate regressions between IDPs and SMs   [IGNORE THIS MESSY SECTION]

NPparameters={};NPparameters.CVscheme=[10 10];NPparameters.Nperm=1;NPparameters.verbose=1;NPparameters.alpha=[0 0.001 0.01 0.1 0.3 0.7 0.99];

% 461(high blood pressure)  also 875
% 1765 fluid intelligence   1768   1774
% 1771 birth weight
% 2541 BMI / body fat 2551  /  2559 BASAL METABOLIC RATE *HUGE*  / 2613 red blood cells
%% I 1982 head bone density / 48 beats in heart wave thingy /

Y=age; % or sex, etc.    Y=varsALL(:,652);

X=[ALL_IDPs(:,19:end) NODEamps25 NODEamps100 NET25 NET100];

age2=nets_demean(age).^2;
conf=[ age age2 sex nets_demean(age).*nets_demean(sex) age2.*nets_demean(sex) ALL_IDPs(:,[12 13 18]) ALL_IDPs(:,18).^(1/3) ];
  % ir
conf=[ sex ALL_IDPs(:,[12 13 18]) ALL_IDPs(:,18).^(1/3) ];

Kp=sum(isnan([X Y conf]),2)==0; KpN=sum(Kp);  100*KpN/N

Y=Y(Kp);  X=X(Kp,:);  X=X./repmat(std(X),size(X,1),1); conf=conf(Kp,:);
NPparameters.Nfeatures = round(size(X,2)/50);
[NPpredictedY,NPstats] = nets_predict(Y,X,'gaussian',NPparameters,-1*eye(size(Y,1)),[],conf); NPstats
figure;scatter(Y,NPpredictedY);  corr(Y,NPpredictedY)

%%%%%%%%%%%%%%%%% Fidel's abstract
%%%% 1
scatter(age,-ALL_IDPs(:,23)); corr(age,-ALL_IDPs(:,23))
set(gcf,'PaperPositionMode','auto','Position',[10 10 500 500]); print('-dpng',sprintf('scatter1.png'));
%%%% 2
Y=age; X=ALL_IDPs(:,19:748); conf=[sex ALL_IDPs(:,[12 13 18]) ALL_IDPs(:,18).^(1/3)]; Kp=sum(isnan([X Y conf]),2)==0; KpN=sum(Kp);  100*KpN/N
Y=Y(Kp);  X=X(Kp,:);  X=X./repmat(std(X),size(X,1),1); conf=conf(Kp,:);
NPparameters.Nfeatures = round(size(X,2)/2);
[NPpredictedY,NPstats] = nets_predict(Y,X,'gaussian',NPparameters,-1*eye(size(Y,1)),[],conf); NPstats
figure;scatter(Y,NPpredictedY);  corr(Y,NPpredictedY)
set(gcf,'PaperPositionMode','auto','Position',[10 10 500 500]); print('-dpng',sprintf('scatter2.png'));
%%%% 3
Y=age(K); X=[grot25 grot100]; conf=[sex ALL_IDPs(:,[12 13 18:28]) ALL_IDPs(:,[18:28]).^(1/3)]; conf=conf(K,:); Kp=sum(isnan([X Y conf]),2)==0; KpN=sum(Kp);  100*KpN/N
Y=Y(Kp);  X=X(Kp,:);  X=X./repmat(std(X),size(X,1),1); conf=conf(Kp,:);
NPparameters.Nfeatures = round(size(X,2)/2);
[NPpredictedY,NPstats] = nets_predict(Y,X,'gaussian',NPparameters,-1*eye(size(Y,1)),[],conf); NPstats
figure;scatter(Y,NPpredictedY);  corr(Y,NPpredictedY)
set(gcf,'PaperPositionMode','auto','Position',[10 10 500 500]); print('-dpng',sprintf('scatter3.png'));


Y=age; X=[ALL_IDPs(:,19:end) NODEamps25 NODEamps100 NET25 NET100];


Y=ALL_IDPs(:,254)
ALL(:,2390);


% results fpr intelligence predictedcorr (always including basic IDPs):
% NET25=0.13 NET100= NODEamps25=0.07 NODEamps100=0.06  NET25+NODEamps25=0.14

% results for cog prediction  Y=varsALL(:,652)    20159-0.0 Number of symbol digit matches made correctly    Nfeatures   cod / cod_deconf / corr
% X=ALL_IDPs(:,19:end); conf= HUGE                                                                              N/2     0.0080  0.0109 0.1056
% X=ALL_IDPs(:,19:end); conf= HUGE                                                                              N/20    0.0044  0.0089 0.0843
% X=[NODEamps25 NODEamps100 NET25 NET100]; conf=HUGE                                                            N/2    -0.0107 -0.0130 0.1059
% X=[NODEamps25 NODEamps100 NET25 NET100]; conf=HUGE                                                            N/20   -0.0263 -0.0356 0.0894

% X=ALL_IDPs(:,19:end);                    conf=[ sex ALL_IDPs(:,[12 13 18]) ALL_IDPs(:,18).^(1/3) ];           N/2     0.1333  0.1379 0.3641
% X=ALL_IDPs(:,19:end);                    conf=[ sex ALL_IDPs(:,[12 13 18]) ALL_IDPs(:,18).^(1/3) ];           N/20    0.1190  0.1230 0.3438
% X=[NODEamps25 NODEamps100 NET25 NET100]; conf=[ sex ALL_IDPs(:,[12 13 18]) ALL_IDPs(:,18).^(1/3) ];           N/2     0.0856  0.0896 0.2948
% X=[NODEamps25 NODEamps100 NET25 NET100]; conf=[ sex ALL_IDPs(:,[12 13 18]) ALL_IDPs(:,18).^(1/3) ];           N/20    0.0516  0.0553 0.2370
% X=[NET25 NET100];                        conf=[ sex ALL_IDPs(:,[12 13 18]) ALL_IDPs(:,18).^(1/3) ];           N/20    0.0548  0.0567 0.2477
% X=[NODEamps25 NODEamps100];              conf=[ sex ALL_IDPs(:,[12 13 18]) ALL_IDPs(:,18).^(1/3) ];           N/2     0.0334  0.0347 0.1815
% X=[NODEamps25 NODEamps100];              conf=[ sex ALL_IDPs(:,[12 13 18]) ALL_IDPs(:,18).^(1/3) ];           N/20    0.0318  0.0332 0.1759
% X= HUGE                                  conf=[ sex ALL_IDPs(:,[12 13 18]) ALL_IDPs(:,18).^(1/3) ];           N/20    0.1220  0.1263 0.3484



sexP=zeros(N,1)/0; sexP(Kp)=NPpredictedY;
ageP=zeros(N,1)/0; ageP(Kp)=NPpredictedY;

grot=corr([age ageP sex sexP],[vars(:,varskeep) varsI(:,varskeepI)],'rows','pairwise','type','Spearman');

scatter( (grot(1,:)+grot(2,:))/2 , grot(1,:)-grot(2,:) )
scatter( (grot(3,:)+grot(4,:))/2 , grot(3,:)-grot(4,:) )

Y=[vars(:,[1855:1869]) vars(:,1858)-vars(:,1860) vars(:,1867)-vars(:,1869)];
% or
Y=varsALL;
clear grot;
for i=1:size(Y,2)
  i
  poop=robustfit(inormal([age ageP sex sexP]),inormal(Y(:,i))); grot(1:4,i)=poop(2:5);
  poop=robustfit(inormal([age ageP sex sexP ALL_IDPs(:,[12 13 18])]),inormal(Y(:,i))); grot(5:8,i)=poop(2:5);
  poop=robustfit(inormal([age ageP sex sexP ALL_IDPs(:,[12 13 18:28])]),inormal(Y(:,i))); grot(9:12,i)=poop(2:5);  % this is the most "conservative" test of whether ageP is useful
  grot(13:16,i)=corr([age ageP sex sexP],Y(:,i),'rows','pairwise','type','Spearman');
end
plot(grot([1 2 5 6 9 10],:)');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  MISCELLANY

%%% find typical subject .......
grot=nets_normalise([ALL_IDPs(:,2:18) age age age age age]);
[grotY,grotI]=sort(mean(abs(grot-repmat(nanmedian(grot),size(grot,1),1)),2));
MATCH(grotI(1),2)  % 5886701

%%% yearly periodicity
grotSIN=corr(sin(2*pi*(scan_date(K)-round(scan_date(K)))),NETd,'rows','pairwise','type','Spearman')';
grotCOS=corr(cos(2*pi*(scan_date(K)-round(scan_date(K)))),NETd,'rows','pairwise','type','Spearman')';
plot([ grotSIN-.5 grotCOS sqrt(grotSIN.^2+grotCOS.^2)+.5 ])

%%% counts of IDPs

grot=ALL_IDPs(scan_date>2014.7 & ~isnan(ALL_IDPs(:,19)),[19 7 44 74 58 15]);  % T1 T2 SWI dMRI tfMRI rfMRI
100*sum(~isnan([grot mean(grot,2)]))/length(grot) % 100.0 97.0 93.2 95.4 92.0 95.2 88.8



K=sum(isnan(NET25),2)==0; KN=sum(K);   100*KN/N
NET=NET25(K,:);
  NET1=demean(NET);     NET1=NET1/std(NET1(:));
  amNET=abs(mean(NET));  NET3=demean(NET./repmat(amNET,size(NET,1),1));  NET3(:,amNET<0.1)=[]; NET3=NET3/std(NET3(:));
  grot25=[NET1 NET3]; % or any other combination
NET=NET100(K,:);
  NET1=demean(NET);     NET1=NET1/std(NET1(:));
  amNET=abs(mean(NET));  NET3=demean(NET./repmat(amNET,size(NET,1),1));  NET3(:,amNET<0.1)=[]; NET3=NET3/std(NET3(:));
  grot100=[NET1 NET3]; % or any other combination
grotUa=inormal(ALL_IDPs(K,19:73));                                                             % no pre-reduction for the smaller modalities
grot=inormal(ALL_IDPs(K,74:end)); grotK=max(isnan(grot),[],2)==0; [grotU,~,~]=nets_svds(grot(grotK,:),80); % dMRI to dimensionality 80
grotUb=zeros(sum(K),80)/0; grotUb(grotK,:)=grotU;
[grotUc,~,~]= nets_svds(inormal([NODEamps25(K,:) NODEamps100(K,:)]),20); % node amplitudes to dimensionality 20
[grotUd,~,~]= nets_svds([grot25 grot100],80); % maybe less than 100  % netmats to dimensionality 100
NETd=[grotUa grotUb grotUc grotUd];
NETdCOV=zeros(size(NETd,1));
for i=1:size(NETd,1)
  i
  for j=i:size(NETd,1)
    grot=NETd([i j],:); grot=cov(grot(:,sum(isnan(grot))==0)'); NETdCOV(i,j)=grot(1,2); NETdCOV(j,i)=grot(1,2);
  end
end
NETdCOV2=nearestSPD(NETdCOV);  corr(NETdCOV(:),NETdCOV2(:))  % scatter(NETdCOV(:),NETdCOV2(:));
[uu1raw,dd]=eigs(NETdCOV2,Nkeep);    [~,grot]=eig(NETdCOV2); grot=flipud(diag(grot)); 100*sum(grot(1:Nkeep))/sum(grot)   % 98.5

grot=(age(K)-min(age(K)))/(max(age(K))-min(age(K)));
scatter(uu1raw(:,1),uu1raw(:,3), 30 ,  [ grot 1-grot sex(K) ] );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%% matched groups stuff

bp=mean(BloodPressures(K,:),2); bpMATCH=[age(K) sex(K)];
%bpLOW=find(bp>prctile(bp,2) & bp<prctile(bp,10)); bpHIGH=find(bp>prctile(bp,90) & bp<prctile(bp,98));
bpLOW=find(bp<prctile(bp,25)); bpHIGH=find(bp>prctile(bp,75));
bpDIFF=zeros(length(bpLOW),length(bpHIGH));
for i=1:length(bpLOW)
  bpDIFF(i,:) = ( abs(bpMATCH(bpLOW(i),1)-bpMATCH(bpHIGH,1)) + 1000*(bpMATCH(bpLOW(i),2)-bpMATCH(bpHIGH,2)).^2 )';
end
bpPAIRS=[];
while min(bpDIFF(:))<5
  [i,j]=find(bpDIFF==min(bpDIFF(:))); i=i(1); j=j(1);
  bpDIFF(i,:)=1e9; bpDIFF(:,j)=1e9;
  bpPAIRS=[bpPAIRS; bpLOW(i) bpHIGH(j)];
end
grot=age(K); figure;
subplot(1,2,1); scatter(grot(bpPAIRS(:,1)),grot(bpPAIRS(:,2)));
subplot(1,2,2); hist([ grot(bpPAIRS(:,1)) grot(bpPAIRS(:,2)) ]);
mean([ grot(bpPAIRS(:,1)) grot(bpPAIRS(:,2)) ])
std([ grot(bpPAIRS(:,1)) grot(bpPAIRS(:,2)) ])

%%%%%%%%%

bpK=find(sum(isnan([ ALL_IDPs age sex BloodPressures Hypertension ]),2)==0); length(bpK)
bp=mean(BloodPressures(bpK,:),2);
bpSEX=sex(bpK);
bpLOW=find(bp>prctile(bp,2) & bp<prctile(bp,5));
bpHIGH=find(bp>prctile(bp,95) & bp<prctile(bp,98));
bpN=10;
grot=find(bpSEX(bpLOW)==0); grot=grot(randperm(length(grot))); grot1=grot(1:bpN);
grot=find(bpSEX(bpLOW)==1); grot=grot(randperm(length(grot))); grot2=grot(1:bpN);
bpLOW=bpLOW([grot1;grot2]);
grot=find(bpSEX(bpHIGH)==0); grot=grot(randperm(length(grot))); grot1=grot(1:bpN);
grot=find(bpSEX(bpHIGH)==1); grot=grot(randperm(length(grot))); grot2=grot(1:bpN);
bpHIGH=bpHIGH([grot1;grot2]);
bpALL=[bpLOW;bpHIGH];
bpVARS=[ MATCH(:,1) sex age BloodPressures Hypertension ALL_IDPs(:,[12 13 18])]; bpVARS=bpVARS(bpK(bpALL),:); save('bpVARS','bpVARS');
MATCH(bpK(bpALL),2)

grot=corr([NODEskew25(K,20) NODEskew100(K,[3 8 14 19])],varsd,'rows','pairwise');