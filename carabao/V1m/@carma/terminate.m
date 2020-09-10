function o = terminate(o,flag)
%
% TERMINATE  Set stop flag in order to terminate a loop.
%
%    Stop flag is cleared by TIMER function. In orrder to re-set stop
%    flag the terminate function needs to be called in a keypress
%    handler function
%
%       terminate(o,true);             % force termination
%       terminate(o,false);            % clear stop flag
%       terminate(o);                  % same as terminate(o,true);
%
%    Example
%
%       o = timer(o,0.1);              % set timer, clear stop flag
%       while (~stop(o))
%          % do something
%          o = wait(o);                % wait for timer
%       end
%
%    To stop above loop you have to call terminate in a keypress
%    function, e.g.
%
%       function Stop(o)               % handler called by keypress event
%          terminate(o);
%       return;
%
%    See also: CARMA, TIMER, TERMINATE, WAIT
%
   if (nargin < 2)
      flag = true;                     % force termination
   end
   
   control(o,'stop',flag);
end
