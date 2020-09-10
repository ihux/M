function [ix,iy] = direction(me,p)%% DIRECTION Locate direction where nodes are, return indices of neighbored nodes%          %              [ix,iy] = direction(me,p) % ix: indication x, iy: indication y%              [ixy] = direction(me,p)   % ixy = [ix;iy]%%           direction matrix%%              [Ix,Iy] = direction(p)%%           indication is -1, 0 or +1, depending on the direction%   if (nargin == 1)  % calculate matrix      p = me;                         % shift input args      Ix = [];  Iy = [];      for (i=1:length(p))         [ix,iy] = Single(i,p);         Ix = [Ix;ix];  Iy = [Iy;iy];      end      ix = Ix;  iy = Iy;              % store to out args      return   end      if (nargin == 2 && ~isnan(me))      [ix,iy] = Single(me,p);      if (nargout <= 1)         ix = [ix;iy];      end      return   endendfunction [ix,iy] = Single(me,p)%% SINGLE Locate direction where nodes are, return indices of neighbored nodes%          %              [ix,iy] = single(me,p) % ix: indication x, iy: indication y      [m,n] = size(p);   p0 = p(:,me);          % position of myself      for (j = 1:n)      ix(j) = 0;          % default      if (p(1,j) >= p0(1) + 0.5)         ix(j) = 1;      end      if (p(1,j) <= p0(1) - 0.5)         ix(j) = -1;      end         iy(j) = 0;          % default      if (p(2,j) >= p0(2) + 0.5)         iy(j) = 1;      end      if (p(2,j) <= p0(2) - 0.5)         iy(j) = -1;      end      endend
