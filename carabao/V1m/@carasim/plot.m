function plot(o)
% 
% plot   Plot CARASIM object
%      
%             plot(o)                  % plot CARASIM object
%
%        See also: CARASIM
%
   switch kind(o)
      case 'process'
         PlotProcess(o)
      otherwise
         PlotOther(o);
   end    
end

%==========================================================================
% Helper Functions
%==========================================================================

function PlotOther(o)
   [x,y] = points(o);
   x = [x(1) x(1) x(2) x(2) x(1)];
   y = [ 0   y(1) y(2)  0    0];
   col = color(o); 
   hdl = patch(x,y,col);
   
   name = getp(o,'name');
   duration = getp(o,'duration');
   txt = getp(o,'text');
   str = o.iif(o.is(txt),[' (',txt,')'],'');
   title([carma.capital(o.type),': ',name,str]);
   xlabel(sprintf('Duration: %g',duration));
   set(gca,'visible','on')   ;
   %set(gca,'xtick',[],'ytick',[]);
   
   hdl = text((min(x)+max(x))/2,(min(y)+max(y))/2,name);
   set(hdl,'verticalalignment','middle','horizontalalignment','center');
end

function PlotProcess
         base = baseline(dp);
         lastxy = zeros(length(base),2);
         tend = 0;
         period = getp(dp,'period'); 
         skip = getp(dp,'baseskip');
         
         cls(nano);   % clear screen
         chains = getp(dp,'list');
         n = length(chains);
            
            % main loop 
         
         for (i=1:n)
            ch = chains{i};
            steps =  getp(ch,'list');   % get steps of chain
            col = color(chains{i});
            colors{i} = col;
            [x,y] = points(ch);
            width = getp(ch,'linewidth');
            
            %hdl = plot(x,y+base(i));
            %set(hdl,'linewidth',width,'color',col);
            
            xyc = points(ch);
            x0 = 0;  y0 = base(i);  
            k = 0;
            for (j=1:3:length(xyc))
               k = k+1;
               if (~isempty(x) & ~isempty(y))
                  x = xyc{j};  y = xyc{j+1} + base(i);
                  hdl = plot([x0 x(1)],[y0 y(1)]); 
                  set(hdl,'linewidth',1,'color',col);
                  x0 = x(length(x));  y0 = y(length(y));
                  if (mode==0)
                     hdl = plot(x,y);
                     set(hdl,'linewidth',width,'color',col);
                  else  % patch mode
                     yb = base(i);
                     %hdl = patch([x0 x0 x(1) x(1) x0],[yb y0 y(1) yb yb],col); 
                     %set(hdl,'linewidth',1);
                     x0 = x(length(x));  y0 = y(length(y)); 
                     x = [x(1) x x(length(x)) x(1)];
                     y = [yb y yb yb];
                     step = steps{k};
                     scol = color(step);
                     hdl = patch(x,y,scol);
                     %set(hdl,'color',col);
                     
                     % callback to handle click on object, userdata points to object
                     set(hdl,'userdata',step);                   
                     set(hdl,'ButtonDownFcn','open(get(gcbo,''userdata''))');                     
                  end
                  lastxy(i,1:2) = [x0 y0];
                  tend = max(tend,max(x(:)));
                  hold on
               end
            end
         end

            % plot threads

         threads = getp(dp,'threads');
         if ~isempty(threads)
            for (aa=1:2)
               for (ii=1:length(threads))
                  thread = threads{ii};
                  ci = thread{1};
                  x = thread{2};
                  if ( (aa==1 & x(1) ~= x(2)) | ((aa==2) & x(1)==x(2)) )
                     y = thread{3} + base(ci);
                     hdl = plot(x,y);
                     set(hdl,'color',colors{ci(1)});
                     hdl = plot(x(2),y(2),'s');
                     set(hdl,'color',colors{ci(1)});
                     hdl = plot(x(1),y(1),'o');
                     set(hdl,'color','k');
                  end
               end
            end
         end
         
         if (isempty(period)) xlim = get(gca,'xlim'); else xlim = [0 period]; end
         
         font = getp(dp,'fontsize');
         for (i=1:n)
            plot(xlim,base(i)*[1 1],'k:'); 
            el = element(dp,i);
            txt = getp(el,'text');
            rng = range(el);
            hdl = text(mean(xlim(:)),base(i)+max(rng)*2/3,txt);
            set(hdl,'verticalalignment','middle','horizontalalignment','center');
            set(hdl,'color',color(chains{i}),'fontsize',font);
         end
         
         ylim = get(gca,'ylim');
         ylim(1) = min(ylim(1),0);
         ylim(2) = ylim(2)+skip;
         set(gca,'ylim',ylim);
         
         tit = ['Process: ',name(dp)];
         txt = getp(dp,'text');

         if (~isempty(txt)) 
            tit = [tit,' (',txt,')']; 
         end
         title(tit);
         set(gca,'ytick',[]);
         
            % draw lines at end of chains
         
         for (i=1:length(base))
            hdl = plot([lastxy(i,1) tend],lastxy(i,2)*[1 1]);
            set(hdl,'color',color(chains{i}));
         end
         
            % plot labels
         
         x0 = 0;
         
         for (i=1:length(chains))
            ch = chains{i};
            sz = sizes(ch);
            for (j=1:sz(2))
               el = element(ch,j);
               [x,y] = points(el);
               x1 = min(x);
               if (x1 > x0)
                  dt = sprintf('%g',round(x1-x0));;
                  hdl = text((x0+x1)/2,base(i),dt);
                  set(hdl,'verticalalignment','top','horizontalalignment','center','fontsize',font,'color','k');
               end
               offset = 0.5*rem(j,2);
               
               %hdl = text((min(x)+max(x))/2,base(i)+offset,name(el));
hdl = text(x0+(min(x)+max(x))/2,base(i)+offset,name(el));
               set(hdl,'verticalalignment','bottom','horizontalalignment','center','fontsize',font,'color','k');
               
               dt = sprintf('%g',round(max(x)-min(x)));;
               %hdl = text((min(x)+max(x))/2,base(i),dt);
hdl = text(x0+(min(x)+max(x))/2,base(i),dt);
               set(hdl,'verticalalignment','top','horizontalalignment','center','fontsize',font,'color','k');
               x0 = x0 + max(x);
            end
         end
         
            % search for longest critical path
         
         critical = getp(dp,'critical');
         if isempty(critical)
            return
         end
         
         ci = 0;  maxlen = 0;
         for (i=1:n)
            l = length(critical{i,1});
            if (l >= maxlen)
               maxlen = l;  ci = i;
            end
         end
         path = critical{ci,1};
         
            % plot critical path
               
         x0 = [0 0];  y0 = [0 0];
         for (j=1:length(path))
            thread = path{j};
            ci = thread{1};
            x1 = thread{2};
            y1 = thread{3};
            hdl = plot([x0(2) x1],[y0(2) y1]+[base(ci(1)) base(ci)]);
            set(hdl,'color','k','linestyle','-.','linewidth',2);
            x0 = x1;  y0 = y1;
            %hold on
         end
         
         figure(gcf);  % shg
         
end