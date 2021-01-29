function [K,f] = stable(o,varargin)    % Critical Stability Gain/Frequency
%
% STABLE   Calculate critical gain & frequency for closed loop stability
%
%             Lmu = cook(o,'Lmu');
%             [K,f] = stable(o,Lmu);   % calc critical K value & omega
%
%             stable(o,Lmu)            % plot K range for stability
%             stable(o)                % cook L0 from object 
%
%             sys0 = system(corasim,A0,B0,C0,D0)
%             [K,f] = stable(o,sys0,mu)
%             stable(o,sys0,mu)
%
%          Options:
%             contact       single (0) or multi (1) contact
%
%          Copyright(c): Bluenetics 2020
%
%          See also: SPM, COOK
%
  oo = o;
  %[oo,~,rfr] = cache(oo,oo,'trf');
  %[oo,~,rfr] = cache(oo,oo,'process');
  contact = opt(o,{'contact',0});
  
  if (nargin == 1)
     if (contact == 0)    % single contact
        Lmu = cook(oo,'Lmu');
     else
        Sys0 = cook(oo,'Sys0');
        mu = opt(oo,{'process.mu',0.1});
     end
        
  elseif (nargin == 2)
     contact = 0;
     Lmu = varargin{1};
  elseif (nargin == 3)
     contact = 1;
     Sys0 = varargin{1};
     mu = varargin{2};
  end
  
  if (nargout == 0)
     if (contact == 0)
        Stable(oo,Lmu);                  % plot
     else
        Stability(oo,Sys0,mu);            % plot
     end
  else
     if (contact == 0)
        [K0,f] = Stable(oo,Lmu);
     else
        [K0,f,Ki] = Stability(oo,Sys0,mu);
     end
        
     if isinf(K0) || (K0 == 0)
        K = K0;  f = inf;
     else
        if (contact == 0)
           oo = opt(oo,'magnitude.low',20*log10(K0*0.95));
           oo = opt(oo,'magnitude.high',20*log10(K0*1.05));
           [K,f] = Stable(oo,Lmu);
        else
           oo = opt(oo,'magnitude.low',20*log10(K0));
           oo = opt(oo,'magnitude.high',20*log10(Ki));
           [K,f] = Stability(oo,Sys0,mu);
        end
     end
   end
end

%==========================================================================
% Helper
%==========================================================================

function [K,f] = Stable(o,L0)
   low = opt(o,{'magnitude.low',-300});
   high = opt(o,{'magnitude.high',100});
   delta = opt(o,{'magnitude.delta',20});

   mag = logspace(low/20,high/20,1000);

   [num,den] = peek(L0);

   for (i=1:length(mag))
      K = mag(i);
      poly = add(L0,K*num,den);
      r = roots(poly);

      if isempty(r)
         re(i) = -inf;
      else
         re(i) = max(real(r));
      end
   end

      % find critical K
      
   K = inf;
   idx = find(re>0);
   if ~isempty(idx)
      idx = max(1,idx(1)-1);
      K = mag(idx);
   end
      
     % calc critical frequency om0

   if (nargout ~= 1)
      L0 = opt(L0,'oscale',oscale(o));
      [Ljw,omega] = fqr(L0);            % frequency response Lmu(jw)
      Sjw = 1 ./ (1 + K*Ljw);           % sensitivity S0(jw)

      magSjw = abs(Sjw);                % sensitivity magnitude
      idx = find(magSjw==max(magSjw));  % maximation index

%     scale = oscale(o);
%     om = omega(idx(1)) / scale;       % critical omega
      om = omega(idx(1));               % critical omega
      f = om/2/pi;
   end
     
        % that's it if output args are provided
      
   if (nargout > 0)
      return
   end
   
      % otherwise plot
      
   dB = 0*re;

   idx = find(re>0);                   % strictly unstable roots
   if ~isempty(idx)
      dB(idx) = 20*log(1+re(idx));
   end

   idx = find(re<0);                   % stable roots
   if ~isempty(idx)
      dB(idx) = 20*log(-re(idx));
   end

   hdl = semilogx(mag,dB);
   hold on;

   lw = opt(o,{'linewidth',1});
   set(hdl,'LineWidth',lw,'Color',0.5*[1 1 1]);

   idx = find(re>0);
   margin = inf;

   if ~isempty(idx)
      semilogx(mag(idx),dB(idx),'r.');
      i = max(1,min(idx)-1);
      margin = mag(i);
   end

   idx = find(re<0);
   if ~isempty(idx)
      semilogx(mag(idx),dB(idx),'g.');
   end

      % plot axes

   col = o.iif(dark(o),'w-.','k-.');
   plot(get(gca,'xlim'),[0 0],col);
   plot([1 1],get(gca,'ylim'),col);
   subplot(o);
   
      % labeling
      
   more = More(o);
   title(sprintf('Stability Margin: %g @ f: %g Hz, omega: %g/s%s',...
         o.rd(margin,2),o.rd(f,1),2*pi*f,more));
   xlabel('K-factor');   
   ylabel('~1 + max(Re\{poles\}) [dB]');
   
   function txt = More(o)              % More Title Text               
      txt = '';  sep = '';
      
      mu = opt(o,'process.mu');
      if ~isempty(mu)
         txt = sprintf('mu: %g',mu);  
         sep = ', ';
      end
      
      vomega = opt(o,{'variation.omega',1});
      if ~isequal(vomega,1)
         txt = [txt,sep,sprintf('vomega: %g',vomega)]; 
         sep = ', ';
      end
      
      vzeta = opt(o,{'variation.zeta',1});
      if ~isequal(vzeta,1)
         txt = [txt,sep,sprintf('vzeta: %g',vzeta)];
         sep = ', ';
      end
      
      if ~isempty(txt)
         txt = [' (',txt,')'];
      end
   end
end
function [K,f,Ki] = Stability(o,sys,mu)
   [A0,B0,C0,D0] = system(sys);

   low = opt(o,{'magnitude.low',-300});
   high = opt(o,{'magnitude.high',100});
   delta = opt(o,{'magnitude.delta',20});

   contact = opt(o,{'contact',0});
   if (contact == 0)
      mag = logspace(low/20,high/20,1000);
   else
      mag = logspace(low/20,high/20,100);
   end
   
%  [num,den] = peek(L0);

   for (i=1:length(mag))
      if ( rem(i,10) == 1 )
         percent = (i-1)/length(mag) * 100;
         msg = sprintf('analyzing %g of %g',i,length(mag));
         progress(o,msg,percent);
      end
      
      K = mag(i);
      %poly = add(L0,K*num,den);
      %r = roots(poly);

      Mu = K*mu;
      Amu = A0 - B0*inv(eye(size(D0))-Mu*D0)*Mu*C0;
      r = eig(Amu);
      
      if isempty(r)
         re(i) = -inf;
      else
         re(i) = max(real(r));
         idx = find(real(r)==re(i));
         im(i) = imag(r(idx(1)));
      end
   end
   progress(o);                        % done

      % find critical K and associated imaginary part
   
   K = inf;
   Ki = max(mag);
   
   idx = find(re>0);
   if ~isempty(idx)
      idx = max(1,idx(1)-1);
      K = mag(idx);
      im = im(idx);
      
      for (j=idx:length(mag))
         if (real(re(j)) >= 0)
            Ki = mag(j);
            break;
         end
      end
   else
      im = 0;
   end
      
     % calc critical frequency om0

   if (nargout ~= 1)
      om = abs(im) / oscale(o);        % critical omega
      f = om/2/pi;
   end
     
        % that's it if output args are provided
      
   if (nargout > 0)
      return
   end
   
      % otherwise plot
      
   dB = 0*re;

   idx = find(re>0);                   % strictly unstable roots
   if ~isempty(idx)
      dB(idx) = 20*log(1+re(idx));
   end

   idx = find(re<0);                   % stable roots
   if ~isempty(idx)
      dB(idx) = 20*log(-re(idx));
   end

   hdl = semilogx(mag,dB);
   hold on;

   lw = opt(o,{'linewidth',1});
   set(hdl,'LineWidth',lw,'Color',0.5*[1 1 1]);

   idx = find(re>0);
   margin = inf;

   if ~isempty(idx)
      semilogx(mag(idx),dB(idx),'r.');
      i = max(1,min(idx)-1);
      margin = mag(i);
   end

   idx = find(re<0);
   if ~isempty(idx)
      semilogx(mag(idx),dB(idx),'g.');
   end

      % plot axes

   col = o.iif(dark(o),'w-.','k-.');
   plot(get(gca,'xlim'),[0 0],col);
   plot([1 1],get(gca,'ylim'),col);
   subplot(o);
   
      % labeling
      
   more = More(o);
   title(sprintf('Stability Margin: %g @ f: %g Hz, omega: %g/s%s',...
         o.rd(margin,2),o.rd(f,1),2*pi*f,more));
   xlabel('K-factor');   
   ylabel('~1 + max(Re\{poles\}) [dB]');
   
   function txt = More(o)              % More Title Text               
      txt = '';  sep = '';
      
      mu = opt(o,'process.mu');
      if ~isempty(mu)
         txt = sprintf('mu: %g',mu);  
         sep = ', ';
      end
      
      vomega = opt(o,{'variation.omega',1});
      if ~isequal(vomega,1)
         txt = [txt,sep,sprintf('vomega: %g',vomega)]; 
         sep = ', ';
      end
      
      vzeta = opt(o,{'variation.zeta',1});
      if ~isequal(vzeta,1)
         txt = [txt,sep,sprintf('vzeta: %g',vzeta)];
         sep = ', ';
      end
      
      if ~isempty(txt)
         txt = [' (',txt,')'];
      end
   end
end