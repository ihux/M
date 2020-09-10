function oo = read(o,varargin)         % Read CUT Object From File 
%
% READ   Read a CUT object from file.
%
%             oo = read(o,'ReadCulCsv',path) % CUL (cut log) CSV file
%
%          See also: CUT, IMPORT, WRITE
%
   [gamma,oo] = manage(o,varargin,@Error,@ReadCulCsv,@ReadSpmSpm);
   oo = gamma(oo);
end

function o = Error(o)                  % Default Error Method          
   error('two input args expected!');
end

%==========================================================================
% Read SPM file 
%==========================================================================

function oo = ReadSpmSpm(o)            % Read Driver for .spm File     
   path = arg(o,1);                    % get path arg
   [dir,file,ext] = fileparts(path);
   
%    try
%       [~,package,pxt] = fileparts(dir);
%       [package,typ,name,run,machine] = split(o,[package,pxt]);
%    catch
%       machine = '';
%    end
   
   oo = construct(o,class(o));    % create class object of type 'SPM'
   oo.type = 'spm';
   
   % read infos
   fid = fopen(path,'r');
   line = fgetl(fid);
   % check correct file format
   if ~isequal(line,'State-Space Matrices File')
      error('Wrong file format. Choose dense format');
      return
   end
   line = fgetl(fid);
   oo.par.notes = oo.trim(line);
   line = fgetl(fid);
   oo.par.date = [line(4:5),'-',line(1:2),'-',line(7:10)];
   oo.par.time = line(17:end);
   line = fgetl(fid);
   oo.par.title = oo.trim(line(8:end));
   % check correct file format
   line = fgetl(fid);
   format = sscanf(line,'%f');
   if ~isequal(format,[0; 0])
      error('Wrong file format. Choose dense format');
      return
   end
   
   % skip to 'INPUT LABELS'
   while (true)
      line = fgetl(fid);
      if isequal(line,' INPUT LABELS')
         break
      end
   end
   
   % read input labels
   in = {};
   while (true)
      line = fgetl(fid);
      if isequal(line,' OUTPUT LABELS')
         break
      else
         in{end+1} = oo.trim(line);
      end
   end   
   
   % read output labels
   out = {};
   while (true)
      line = fgetl(fid);
      if isequal(line,'A MATRIX')
         break
      else
         out{end+1} = oo.trim(line);
      end
   end   
   
   % read matrices
   % we are already at position 'A MATRIX' in the file so no need for
   % skipping lines with matrix A
   A = ReadMatrix(fid);
   B = ReadMatrix(fid,'B');
   C = ReadMatrix(fid,'C');
   D = zeros(size(C,1),size(B,2));
   
   fclose(fid);
   
%    oo.par.package = package;
%    oo.par.machine = machine;
   oo.par.dir = dir;
   oo.par.file = [file,ext];
   oo.par.labelIn = in;
   oo.par.labelOut = out;
   
   header = sprintf('System: A[%dx%d], B[%dx%d], C[%dx%d], D[%dx%d]',...
                    size(A),size(B),size(C),size(D));
   oo.par.comment = {header,['file: ',file,ext],['directory: ',dir]};
                 
   oo.par.system.A = A;
   oo.par.system.B = B;
   oo.par.system.C = C;
   oo.par.system.D = D;
   
   ev = eig(A);       % eigenvalues
   t = 1:length(ev);
   x = real(ev);
   y = imag(ev);
   [~,idx] = sort(abs(imag(ev)));
   
   oo.data.t = t;
   oo.data.x = x(idx)';
   oo.data.y = y(idx)';
   return
   
   function [mat] = ReadMatrix(fid,name)
      % if 'name' is missing, start from current position
      
      mat = [];
      
      if nargin>1
         % skip lines until matrix starts
         while (true)
            l = fgetl(fid);
            if (isequal(l,[name,' MATRIX']))
               break
            end
         end
      end
      
      % read dimensions
      l = fgetl(fid);
      [rows,~] = sscanf(l,'%f');

      % read matrix
      for i=1:rows
         l = fgetl(fid);
         entries = sscanf(l,'%f');
         mat = [mat;entries'];
      end
   end

end

function oo = OldReadSpmSpm(o)            % Read Driver for .spm File     
   path = arg(o,1);                    % get path arg
   [dir,file,ext] = fileparts(path);
   
   try
      [~,package,pxt] = fileparts(dir);
      [package,typ,name,run,machine] = split(o,[package,pxt]);
   catch
      machine = '';
   end
   
   oo = cut('spm');                    % create CUT object of type 'SPM'
   oo.data = [];
   
   fid = fopen(path,'r');
   while (1)
      line = fgetl(fid);
      if (~ischar(line))
         break;
      end
      
      if (strfind(line,'//  Format') == 1)
         oo.par.format = line(13:end);
      elseif (strfind(line,'//  Title') == 1)
         oo.par.title = oo.trim(line(12:end));
      elseif (strfind(line,'//  Date') == 1)
         oo.par.date = [line(17:20),'-',line(14:15),'-',line(11:12)];
      elseif (strfind(line,'//  Time') == 1)
         oo.par.time = line(11:18);
      elseif (strfind(line,'//  Notes') == 1)
         oo.par.notes = oo.trim(line(12:end));
      end

      if isequal(line,'//END ANSOFT HEADER')
         break;
      end
   end

   while (1)
      line = fgetl(fid);
      if (strfind(line,'MatrixA') ~= 0)
         break;
      end
   end
   
       % read matrix A
       
   A = [];
   while (1)
      line = fgetl(fid);
      if (line(end) == '\')
         line(end) == [];
      end
      aT = sscanf(line,'%f')';
      A = [A; aT];
      [m,n] = size(A);
      if (m == n)
         break;
      end
   end
   
   while (1)
      line = fgetl(fid);
      if (strfind(line,'MatrixB') ~= 0)
         break;
      end
   end
   
      % read matrix B
      
   B = [];
   for (i=1:n)
      line = fgetl(fid);
      if (line(end) == '\')
         line(end) == [];
      end
      bT = sscanf(line,'%f')';
      B = [B; bT];
   end
   
   while (1)
      line = fgetl(fid);
      if (strfind(line,'MatrixC') ~= 0)
         break;
      end
   end
   
      % read matrix C
      
   C = [];
   while (1)
      line = fgetl(fid);
      if (strfind(line,')') > 0)
         break;
      end
      if (line(end) == '\')
         line(end) == [];
      end
      cT = sscanf(line,'%f')';
      C = [C; cT];
   end
   
   if (size(B,2) == 1)
      B = [0*B, 0*B, B];
   end
   if (size(C,1) == 1)
      C = [(+1).^(1:length(C))/100; (-1).^(1:length(C))/100; C];
   end
   D = zeros(size(C,1),size(B,2));
   
   fclose(fid);
   
      % done with reading
   
   oo.par.package = package;
   oo.par.machine = machine;
   oo.par.dir = dir;
   oo.par.file = [file,'/',ext];
   
   header = sprintf('System: A[%dx%d], B[%dx%d], C[%dx%d], D[%dx%d]',...
                    size(A,1),size(A,2), size(B,1),size(B,2), ...
                    size(C,1),size(C,2), size(D,1),size(D,2));
   oo.par.comment = {header,['package: ',package],['machine: ',machine],...
                     ['file: ',file,'/',ext],['directory: ',dir]};
                 
   oo.par.parameter.A = A;
   oo.par.parameter.B = B;
   oo.par.parameter.C = C;
   oo.par.parameter.D = D;
   
   oo.par.parameter.vc = 10;    % [m/s] cutting speed
   oo.par.parameter.vs = 0.15;  % [m/s] seek speed
   oo.par.parameter.Fn = 500;
   oo.par.parameter.Sn = 100;
   oo.par.parameter.fn = 8;
   oo.par.parameter.mu = 0.11;
   
   oo.par.simu.tmax = 0.1;
   oo.par.simu.dt = 1e-5;
   
   oo.par.model = @cons1;   % constrained model
end
function oo = ReadCulCsv(o)            % Read Driver for .log File     
   path = arg(o,1);                    % get path arg
   [dir,file,ext] = fileparts(path);
   
   try
      [~,package,pxt] = fileparts(dir);
      [package,typ,name,run,machine] = split(o,[package,pxt]);
   catch
      machine = '';
   end
   
   %PreserveVariableNames = true;      % preserve original variable names
   T = readtable(path);                % read .CSV file into table
   M = table2array(T);
   names = T.Properties.VariableNames;
   
   oo = cut('cul');                    % create CUT object of type 'CUL'
   oo.par.title = file;
   oo.par.package = package;
   oo.par.machine = machine;
   oo.par.dir = dir;
   oo.par.file = [file,'/',ext];
   
   oo.par.comment = {['package: ',package],['machine: ',machine],...
                     ['file: ',file,'/',ext],['directory: ',dir]};
   oo = Extract(oo,oo.par.title);
                  
   zero = zeros(1,size(M,1));
   oo = data(oo,'t',zero);
   oo = data(oo,'ax',zero);
   oo = data(oo,'ay',zero);
   oo = data(oo,'az',zero);
   oo = data(oo,'bx',zero);
   oo = data(oo,'by',zero);
   oo = data(oo,'bz',zero);

   for (i=1:length(names))
      name = names{i};
      switch name
         case 'Time_s_'
            oo = data(oo,'t',M(:,i)');
         case 'Acc_X_Kappl_g_'
            oo = data(oo,'ax',M(:,i)');
         case 'Acc_Y_Kappl_g_'
            oo = data(oo,'ay',M(:,i)');
         case 'Acc_Z_Kappl_g_'
            oo = data(oo,'az',M(:,i)');
         case 'Acc_X_Kolben_g_'
            oo = data(oo,'bx',M(:,i)');
         case {'Acc_Y_Kolben_g_','Acc_YKolben_g_'}
            oo = data(oo,'by',M(:,i)');
         case 'Acc_Z_Kolben_g_'
            oo = data(oo,'bz',M(:,i)');
      end
   end
end

%==========================================================================
% extract parameters from file title
%==========================================================================

function o = Extract(o,title)                                          
   text = ['_',title,'_'];
   idx = find(text=='_');
 
      % split up text into chunks
      
   chunks = {};
   for (i=2:length(idx))
      chunk = text(idx(i-1)+1:idx(i)-1);
      chunks{end+1} = chunk;
   end
   
      % extract number
      
   while (1)
      number = chunks{end};
      o.par.number = sscanf(number,'%f');
      
      if ~isempty(o.par.number)
         break;
      end
      nick = get(o,{'nick',''});
      o = set(o,'nick',[nick,' ',chunks{end}]);
      chunks(end) =[];  % otherwise repeat
   end

      % extract lage
      
   lage = chunks{end-1};
   o.par.lage = sscanf(lage,'Lage%f');
   if ~isa(o.par.lage,'double')
      o.par.lage = NaN;
   end
   
      % extract date
      
   date = chunks{1};
   o.par.date = ['20',date(1:2),'-',date(3:4),'-',date(5:6)];
      
      % extract machine and station
   
   o.par.machine = chunks{2};
   o.par.station = chunks{3};
   
      % extract article and kappl

   o.par.article = chunks{4};
   o.par.kappl = chunks{5};
   
      % extract facette angle
      
   art = get(o,'article');
   if ~isempty(art)
      ao = article(o,art);
      tags = fields(o.either(get(ao),struct));
      for (i=1:length(tags))
         tag = tags{i};
         if isequal(strfind(tag,'facette'),1)
            o = set(o,tag,get(ao,tag));
         end
      end
   end
   
      % set angle
      
   oo = article(o,o.par.article);
   if ~isempty(oo)
      o.par.angle = angle(oo,get(o,{'lage',0}));
   end
   
      % copy info from package object
      
   %o = Package(o);
end
function oo = OldPackage(o)                                            
   oo = o;                           % copy to output (default)
   package = get(o,'package');
   list = data(pull(o));             % get shell's object list

   if (o.is(package) && iscell(list) && o.is(list))
      for (i=1:length(list))
         oi = list{i};
         if isequal(type(oi),'pkg') && isequal(get(oi,'package'),package)
            oo = set(oo,'station',get(oi,'station'));
            oo = set(oo,'kappl',get(oi,'kappl'));
            oo = set(oo,'vcut',get(oi,'vcut'));
            oo = set(oo,'vseek',get(oi,'vseek'));
            break;                   % we are done
         end
      end
   end
end
