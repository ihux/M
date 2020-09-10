function oo = server(o,bag)            % Create a Carabase Server Object 
%
% SERVER   Create a CARABASE server object with query info from bag. 
%
%    A Carabase object is generated with query information which is com-
%    posed from the provided bag information. If for some reason CARABASE
%    class is not accessible (e.g. not configured, then query returns an 
%    empty object [].
%
%       o = server(carabull,bag)       % return carabase object, or empty
%
%    Remarks: bag must be a structure with the following 5 member tags:
%    tag, type, par, data and work.
%
%    Code lines: 37
%
%    See also: CARABULL, CARABASE
%
   either = util(o,'either');          % ned some utility
   
   o = work(caracow,'var.bag',bag);    % store bag in work variables
   
   nowstr = datestr(now);
   date = either(work(o,'var.bag.date'),nowstr(1:11));
   time = either(work(o,'var.bag.time'),nowstr(13:20));
   tvec = datevec([date,' ',time]);
%
% get comment and make proper treatments
%
   comment = either(work(o,'var.bag.comment'),{});
   if ischar(comment)
      comment = {comment};
   end
%
% construct serial list
%
   serials = {};
   serial = work(o,'var.bag.serial');
   if ~isempty(serial)
      serials{end+1} = serial;
   end
%
% Get author
%
   import java.lang.*;                 % need Java!
   author = System.getProperty('user.name');
   author = char(author);
%
% add time stamp
%
   stamp = datenum(tvec);
%
% time vector and comment has been calculated. setup query info ...
%
   q.title = either(work(o,'var.bag.title'),'');
   q.comment = comment;
   q.project = either(work(o,'var.bag.project'),'');
   q.serial = serials;
   q.datenum = stamp;
   q.kind = either(work(o,'var.bag.kind'),{});
   if ~isempty(q.kind)
      q.kind = {q.kind};               % kind must be a list of kinds
   end
   q.author = either(author,'');
   q.class = class(o);
   
   oo = carabase(q);                   % construct Carabase object
end

