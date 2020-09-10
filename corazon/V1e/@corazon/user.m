function out = user(o,tag)
%
% USER   Get user information
%
%           name = user(o,'name')      % user name
%           home = user(o,'home')      % user home directory
%           dir = user(o,'dir')        % user working directory
%
%    Copyright(c): Bluenetics 2020 
%
%    See also: CORAZON
%
   import java.lang.*;                 % need Java!
   
   switch char(tag)
      case 'name'
         name = System.getProperty('user.name');
         out = char(name);
      case 'home'
         home = System.getProperty('user.home');
         out = char(home);
      case 'dir'
         dir = System.getProperty('user.dir');
         out = char(dir);
      otherwise
         error('bad tag!');
   end
end