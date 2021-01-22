function [K,f] = stable(o,Lmu)         % Critical Stability Gain/Frequency
%
% STABLE   Calculate critical gain & frequency for closed loop stability
%
%             Lmu = cook(o,'Lmu');
%             [K,f] = stable(o,Lmu);   % calc critical K value & omega
%
%             stable(o,Lmu)            % plot K range for stability
%             stable(o)                % cook L0 from object 
%
%          Copyright(c): Bluenetics 2020
%
%          See also: SPM, COOK
%
  oo = o;
  %[oo,~,rfr] = cache(oo,oo,'trf');
  %[oo,~,rfr] = cache(oo,oo,'process');
  
  if (nargin == 1)
     Lmu = cook(oo,'Lmu');
  end
  
  if (nargout == 0)
     Stable(oo,Lmu);                     % plot
  else
     [K0,f] = Stable(oo,Lmu);
     if isinf(K0) || (K0 == 0)
        K = K0;  f = inf;
     else
        oo = opt(oo,'magnitude.low',20*log10(K0*0.95));
        oo = opt(oo,'magnitude.high',20*log10(K0*1.05));
        [K,f] = Stable(oo,Lmu);
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