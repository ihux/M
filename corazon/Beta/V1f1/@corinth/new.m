function oo = new(o,varargin)          % CORINTH New Method              
%
% NEW   New CORINTH object
%
%           oo = new(o,'Menu')         % menu setup
%
%           o = new(corinth,'Base10')    % some base 10 ratio 
%           o = new(corinth,'Base100')   % some base 100 ratio
%           o = new(corinth,'Pi')        % pi as a base 1e6 ratio
%
%       See also: CORINTH, TRIM, ADD, SUB, MUL, DIV, COMP
%
   [gamma,oo] = manage(o,varargin,@Base100,@Base10,@Pi,@Menu);
   oo = gamma(oo);
end

%==========================================================================
% Menu Setup
%==========================================================================

function oo = Menu(o)                  % Setup Menu
   oo = mitem(o,'Numbers');
   ooo = mitem(oo,'Base 10 Ratio',{@Callback,'Base10'});
   ooo = mitem(oo,'Base 100 Ratio',{@Callback,'Base100'});
   ooo = mitem(oo,'Pi @ Base 1e6 Ratio',{@Callback,'Pi'});

   oo = mitem(o,'Polynomial');
   ooo = mitem(oo,'Order 4',{@Callback,'Poly4'});

   oo = mitem(o,'Rational Function');
   ooo = mitem(oo,'Order 5',{@Callback,'Ratio5'});
end
function oo = Callback(o)
   mode = arg(o,1);
   o = base(o);                        % convert in case of container
   
   mode = arg(o,1);
   switch mode
      case 'Base10'
         o = base(corinth,10);
         oo = number(o,[7 3 8 5],[8 9]);
      case 'Base100'
         o = base(corinth,100);
         oo = number(o,[73 85 56 18],[18 29]);
      case 'Pi'
          oo = number(o,pi);

      case 'Poly4'
         oo = poly(o,[1.11 2.22 3.33 4.44 5.55]);
         oo.par.title = 'Order 4 Polynomial';
      
      case 'Ratio5'
         oo = ratio(o,[27.3 45.7 88.8 72.1 78.5 44],...
                      [1 47.5 77.7 27.2 87.9 33]);

      otherwise
         error('internal');
   end
   paste(o,oo);                        % paste object into shell
end

