function oo = inherit(oo,o)
%
% INHERIT   Inherit work properties properly
%
%    If control(o,'options') is true then children's options are inherited
%    from the container, otherwise they are not affected.
%
%       oo = inherit(oo,o);            % inherit work property properly
%
%    Exceptions: the following options are not transfered from the container
%    to the child object:
%
%       opt(o,'control.color')         % figure background color
%       opt(o,'control.launch')        % launch function
%
%    Furthermore the following work properties have to be inherited:
%
%       work.figure
%       work.object
%       work.event
%       work.arg
%       work.mitem
%  
%    See also: CARABAO, CURRENT, BASKET
%
   options = control(o,{'options',1});
   if (options)                        % means, use parent's opts
      color = opt(oo,'control.color');
      launch = opt(oo,'control.launch'); 
      
      oo = opt(oo,opt(o));
      
      oo = opt(oo,'control.color',color);    % restore option
      oo = opt(oo,'control.launch',launch);  % restore option
   else                                % copy all non-exist parent options
      paropts = opt(o);   parflds = fields(paropts);
      objopts = opt(oo);  objflds = fields(objopts);
      for (i=1:length(parflds))
         tag = parflds{i};
         if ~o.is(tag,objflds)
            oo = opt(oo,tag,opt(o,tag));
         end
      end
   end   
   
   oo.work.figure = work(o,'figure');
   oo.work.object = work(o,'object');
   oo.work.event = work(o,'event');
   oo.work.arg = work(o,'arg');
   oo.work.mitem = work(o,'mitem');
end