function out = plot(obj,hax)
%
% PLOT    Plot a SMART object. First argument can either be a single SMART
%         object or a list (cell array) of SMART objects. In case of a list
%         argument plot is recursively called for each list element.
%
%            plot(obj,hax)            % plot into single 'gca' axis object
%            plot(obj,[ax1,ax2])      % plot to dual axis objects
%            plot({obj1, obj2, obj3})
%
%         Plot function behaves on the data structure itself and on the
%         option settings, which might be defined by a call:
%
%         Example 1:
%            t = 0:pi/50:4*pi;  xy = [sin(t); cos(t)];
%            obj = smart({t,xy});
%            figure(1); 
%            plot(obj);                % single axis; same as plot(obj,gca)
%            figure(2);
%            plot(obj,[subplot(211),subplot(212)]);   % dual axes
%
%         Example 2:
%            obj = smart(gcfo);        % create smart object with options
%                                      % derived from menu/figure
%            obj = set(obj,'color',{'r','g'});
%            plot(obj,[subplot(211),subplot(212)]);
%
%         See also: SMART
%
   hdl = [];                                % init
   if (nargin < 2) hax = gca;  end

   if (iscell(obj))                         % if argument is a list
       held = ishold;
       for (i=1:length(obj))
          hdl(i) = plot(obj{i});            % recursively call the plot function
          hold on;
       end
       if (held)
          hold on;
       else
          hold off;
       end
       if (nargout > 0) out = hdl; end
       return    % done!
   end
   
% Otherwise we have a single object which we go now to plot

   kind = eval('obj.data.kind','???');
   switch kind
       case 'double'
          hdl = plotxy(obj,hax,obj.data.x,obj.data.y);
          if (isfield(obj.data,'yf'))
             bullets = option(obj,'bullets');
             %obj = option(obj,'color',iif(bullets,{'y'},{'y'}));
             %obj = set(obj,'color',{[0.8 0.8 0]});
             obj = set(obj,'color',{'p'});
%            plotxy(obj,hax,obj.data.x,obj.data.yf/factor);   % no handle
             plotxy(obj,hax,obj.data.x,obj.data.yf);         % no handle
          end
       case 'image'
          ydir = get(hax,'ydir');
          hdl = image(obj.data.image);
          if ~isempty(obj.data.cmap)
             colormap(obj.data.cmap);
          end
          set(hax,'ydir',ydir);
          
          position = eval('obj.parameter.position','[0;0]');
          xdata = eval('obj.parameter.xdata','[]');
          ydata = eval('obj.parameter.ydata','[]');
          
          xdata = iif(isempty(xdata),get(hdl,'xdata'),xdata);
          ydata = iif(isempty(ydata),get(hdl,'ydata'),ydata);
          
          set(hdl,'xdata',xdata+position(1),'ydata',ydata+position(2));

       otherwise
          error(['smart::plot(): bad data kind ''',kind,'''!']);
   end

   if (nargout > 0) out = hdl; end
   return
   
%eof      