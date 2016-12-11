function C_map = func_run_proposed_step1(C, B, varargin)

numvarargs = length(varargin);
if numvarargs==1
    I_keep = varargin{1};
    tau_A = 2.6;
elseif numvarargs==2
    I_keep = varargin{1};
    tau_A = varargin{2};
else
    I_keep = ones(384);
    tau_A = 2.6;
end

I_remove = ~I_keep;
ll=1;
C_filt_raw = C;
C_filt_raw(I_remove) = 0;
load 'data/data_supp' M;
M(I_remove) = 0;
nr = 384;
nc = 384;

%load 'censor.mat' I_censor_three_quarters;

%I_censor = I_censor_three_quarters;
%I_keep = ~I_censor;
%M(I_censor) = 0;

%C_filt_raw(I_censor) = 0;
C_filt_raw(M) = -1;
C_filt_blank = C_filt_raw;
for i=1:nr
    for j=1:nc
        if(M(i,j)==1)
            w_x = max(1,i-ll):min(nr,i+ll);
            w_y = max(1,j-ll):min(nc,j+ll);
            ss = C_filt_raw(w_x,w_y);
            vv = ss(:);
            vv(vv==-1) = [];
            C_filt_raw(i,j) =  mean(vv);
        end
    end
end

%tau_A = 2.6;
sc = 100;
AT = @(x) x; A = @(x) x;
finit = C_filt_raw;
Y = round(max(C_filt_raw-B/sc,0.0));
C_map = SPIRALTAP(Y,A,tau_A,...
    'noisetype','poisson',...
    'penalty','tv',...
    'Initialization',finit,...
    'AT',AT,...
    'miniter',5,...
    'maxiter',10,...
    'stopcriterion',3,...
    'tolerance',1e-12,...
    'alphainit',1,...
    'alphamin', 1e-30,...
    'alphamax', 1e30,...
    'alphaaccept',1e30,...
    'logepsilon',1e-10,...
    'saveobjective',1,...
    'savereconerror',1,...
    'savecputime',1,...
    'savesolutionpath',0,...
    'truth',C_filt_raw,...
    'verbose',0);
   

end %function