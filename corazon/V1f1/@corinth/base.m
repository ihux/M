function o = base(o,number)            % Set Basis of CORINTH Object   
%
% BASE    Set basis of a rational object
%
%            o = base(corinth);        % set default basis 1e6
%
%            o = base(corinth,10);     % set basis 10          
%            o = base(corinth,1000);   % set basis 1000          
%            o = base(corinth,1e6);    % set basis 1e6          
%
%         To convert shell object into a base object
%         See also: CORINTH, TRIM, NEW
%
   if (nargin < 2)
      if container(o)
         number = get(o,{'base',1e6});
         o.type = 'number';
         
         o.data = [];                  % clear container list
         o.data.expo = 0;
         o.data.num = 0;
         o.data.den = 1;         
      elseif isfield(o.data,'base')
         number = o.data.base;
      else
         number = 1e6;
      end
   end
   
   o.data.base = number;
end
