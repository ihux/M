function idx = cluster(me,dir,p,col)%% CLUSTER   Calculate indices of cluster in given direction. Cluster search%           can be exclusive or inclusive%%              cdx = cluster(me,[1 0],p)     % cluster in east direction   
%              cdx = cluster(me,[-1 -1],p)   % excl. cluster in NW direction   %              cdx = cluster(me,[-1 -1 0],p) % incl. cluster in NW direction   %%           graphical display  if color (arg4) provided:%%              cdx = cluster(me,dir,p,'b')   % graphical display   %%           First arg (me) is the index of the reference sloc%           First index of returned index vector is closest sloc index%   if (nargin < 4)      col = '';                         % no color provided   end         [ix,iy] = direction(me,p);      if (dir(1) > 0 && dir(2) == 0)       % E (east)      idx = find((ix>0)&(iy==0));   elseif (dir(1) > 0 && dir(2) > 0)    % NE (north-east)      if (length(dir) == 2)             % exclusive NE         idx = find((ix>0)&(iy>0));      else                              % inclusive NE         idx = find((ix>=0)&(iy>=0));      end   elseif (dir(1) == 0 && dir(2) > 0)   % N (north)      idx = find((ix==0)&(iy>0));   elseif (dir(1) < 0 && dir(2) > 0)    % NW (north-west)      if (length(dir) == 2)             % exclusive NW         idx = find((ix<0)&(iy>0));      else                              % inclusive NW         idx = find((ix<=0)&(iy>=0));      end   elseif (dir(1) == -1 && dir(2) == 0) % W (west)      idx = find((ix==-1)&(iy==0));   elseif (dir(1) < 0 && dir(2) < 0)    % SW (south-west)      if (length(dir) == 2)             % exclusive SW         idx = find((ix<0)&(iy<0));      else                              % inclusive SW         idx = find((ix<=0)&(iy<=0));      end   elseif (dir(1) == 0 && dir(2) == -1) % S (south)      idx = find((ix==0)&(iy==-1));   elseif (dir(1) > 0 && dir(2) < 0)    % SE (south-east)      if (length(dir) == 2)             % exclusive SE         idx = find((ix>0)&(iy<0));      else                              % inclusive SE         idx = find((ix>=0)&(iy<=0));      end   else      error('assert');   end   if (length(dir) == 2)                % only in exclusive mode      idx = Rearrange(me,dir,p,idx);   end      if (~isempty(col) && ~isempty(idx))      circle(p,idx,col,0.3);      circle(p,idx(1),col,0.4,2)   endend
function rdx = Rearrange(me,dir,p,idx)%% REARRANGE  Rearrange index vector so first index element indicates closest%            sloc%   n = length(idx);   rdx = idx;             % empty by default      if (n <= 1)      return   end   N = 0;          % max nodes in cluster   for (i=1:n)      tmp = idx(i);  idx(i) = idx(1);  idx(1) = tmp;            q = p(:,idx);      cdx = cluster(1,[dir 0],q);     % inclusive search        if (i == 1 || length(cdx) > N)         N = length(cdx);         rdx = idx;      end   endend