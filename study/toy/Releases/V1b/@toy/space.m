function sob = space(obj,varargin)
%
% SPACE      Create a simple or compound Hilbert space. The resulting
%            object is represented by a toy object with type '#SPACE'.
%
%               H = space(toy,labels,matrix)
%
%            Pre-configured Hilbert spaces
%
%               H = space(toy,'spin')        % spin space
%               H = space(toy,'detector')    % space for simple detector
%               H = space(toy,'twin')        % entangeled spins
%
%            Extract space from a projector
%
%               H = space(toy,{'u';'d'});
%               P = projector(H,'u');
%               H = space(P);                % extract projector's space
%
%            A Hilbert space can be of two types:
%               1) simple space
%               2) compound space
%
%            Examples (simple Hilbert space creation):
%
%               H1 = space(toy,1:7);      % Hilbert space of dimension 7
%                                         % indexed by labels 1:7
%
%               H2 = space(toy,0:6);      % Hilbert space of dimension 7
%                                         % indexed by labels 0:6
%
%               labels = {'a','b','c'};
%               H3 = space(toy,labels);   % Hilbert space of dimension 3
%                                         % indexed by labels 'a','b','c'
%            
%            Examples (compound Hilbert space creation):
%
%               H4 = space(toy,H1,H2);    % Tensor product of Hilbert
%                                         % spaces S1�S2
%
%               H5 = space(toy,H1,H2,H3); % Tensor product of Hilbert
%                                         % spaces S1�S2�S3
%
%            Alternative calling syntax for tensor product spaces
%
%               H4 = space(toy,{H1,H2});
%               H5 = space(toy,{H1,H2,H3});
%
%            The type of the space can be checked by property 'simple?',
%            e.g.
%                  
%               p = property(S1,'simple?')        % p = 1
%               p = property(S4,'simple?')        % p = 0
%
%            See also: TOY, BASIS, PROPERTY, SETUP
%
   sizes = [];           % by default empty
   spaces = {};          % by default empty - means simple space
   ilist = varargin;

% One input argument means extraction of the space of a TOY object

   if length(ilist) < 1
      switch type(obj)
         case {'#VECTOR','#PROJECTOR','#OPERATOR','#SPLIT','#UNIVERSE','#HISTORY'}
            dat.space = data(obj,'space');
            sob = toy('#SPACE',[],dat);
            return
         otherwise
            error('at least 2 input args expected!');
      end
   end

% A second string argument will cause a pre-configured space construction

   if (length(ilist) == 1)
      if ischar(ilist{1})
         dummy = [ilist{1},'#'];
         assert(dummy(1)~='#');                  % no '#' leaded strings!
         sob = setup(obj,ilist{1});   % for pre-configs
         return
      end
   end

% handle alternative calling syntax for construction of tensor
% product space
      
   if iscell(ilist{1}) && (length(ilist) == 1)
      alist = ilist{1};
      if ~isempty(alist)
         if isa(alist{1},'toy')
            ilist = alist;
         end
      end
   end
   
% now we have the input arguments in ilist. The first argument can
% be either a hilbert space, or it can be a vector with labels. Let's
% first handle the compound space (Hilbert space type)

   index = [];

   if isa(ilist{1},'toy')
      if ~property(obj,'space?')
         error('All arguments of a tensor product space must be spaces (arg1)!');
      end
      
      for (i=1:length(ilist))
         arg = ilist{i};
         isspace = isa(arg,'toy');
         if (isspace)
            isspace = property(arg,'space?');
         end
         
         if (~isspace)
            error('All arguments of a tensor product space must be spaces!');
         end
      end
      
         % if no error up to here then we have a consistent argument list
         
      spaces = cons(obj,ilist);
      [labels,index,invidx,column] = Compose(spaces);
      
      basis = [];
   end
   
      % otherwise we have to create a simple space
      
   if ~isa(ilist{1},'toy')
      if (length(ilist) == 1)
         basis = [];
      elseif (length(ilist) == 2)
         basis = ilist{2};
      else
         error('Only 2 or 3 args expected for simple space construction!');
      end
      
      labels = ilist{1};
      if (min(size(labels)) > 1)
         %error('nx1 or 1xn label vector expected for arg2!');
      end
      
      if isa(labels,'double')
         vec = labels;
         labels = {};
         for (i=1:size(vec,1))
            for (j=1:size(vec,2)) 
              labels{i,j} = sprintf('%g',vec(i,j));
            end
         end
      elseif iscell(labels)
         labels = Expand(labels);
         for (i=1:size(labels,1))
            for (j=1:size(labels,2))
               if ~ischar(labels{i,j})
                  error('All labels expected in label list (arg2) expected to be string!');
               end
            end
         end
      else
         error('Either double vector or character list expected for labels (arg2)!');
      end

      if (length(basis) > 0)
         if iscell(basis)
            if (length(basis) ~= length(labels))
               error('dimension of labels (arg2) and basis (arg3) must match!');
            end
         elseif isa(basis,'double')
            if any(size(basis) ~= length(labels)*[1 1])
               error('dimension of basis matrix (arg3) must match length of labels (arg2)!');
            end
            B = basis;  basis = {};
            for (i=1:length(B))
               basis{i} = B(:,i);
            end
         else
            error('basis (arg3) must be either nxn double matrix or list of basis vectors!');
         end
      end
   end
   
% Now everything is prepared. We are ready now for the construction 
% of a space object as toy object with '#SPACE' type 
         
   sob = type(toy,'#SPACE');              % generic space
   if isempty(sizes)
      sizes = size(labels);
   end
   if isempty(index)
      index = (1:prod(size(labels)))';
   end
   
   space.list = spaces;
   space.size = sizes;
   space.basis = basis;                   % use the natural basis
   space.labels = labels;
   space.index = index;

   sob = data(sob,'space',space);
   
   assert(sob);
   return
end

%==========================================================================
% Compose Labels & Index vector
%==========================================================================

function [labels,index,invidx,column] = Compose(spaces)
%
% COMPOSE   Compose label matrix and index vector
%
   labels = ComposeLabels(spaces,0);
   column = ComposeLabels(spaces,1);
   
   index = [];  invidx = [];
   labs = labels(:);
   for (i=1:length(labs))
      sym = column{i};
      j = find(strcmp(sym,labs));
      index(i) = j;
      invidx(j) = i;
   end
   return
end

%==========================================================================
% Compose Labels
%==========================================================================

function labels = ComposeLabels(spaces,force)
%
% COMPOSE-LABELS   Compose label matrix
%
%    Syntax
%       labels = ComposeLabels(spaces,0)  % leave matrices
%       labels = ComposeLabels(spaces,1)  % force to column
%
   if (nargin < 2)
      force = 0;   % not forcing to a column label vector 
   end
   
   blabels = property(spaces{end},'labels');
   if (force)
      blabels = blabels(:);
   end
   sizes = property(spaces{1},'size');

   for (q=1:length(spaces)-1)
      k = length(spaces) - q;
      sizeq = property(spaces{q+1},'size');
      sizes = [sizes; sizeq];

      arg = spaces{k};
      alabels = property(arg,'labels');
      if (force)
         alabels = alabels(:);
      end

      [am,an] = size(alabels);
      [bm,bn] = size(blabels);

      for (aj=1:an)                    % regarding cols of mi x ni ilabels
         for (ai=1:am)                 % regarding rows of mi x ni ilabels
            for (bj=1:bn)              % regarding cols of mj x nj jlabels
               for (bi=1:bm)           % regarding rows of mj x nj jlabels
                  i = (ai-1)*bm + bi;
                  j = (aj-1)*bn + bj;
                  composed{i,j} = [alabels{ai,aj},'�',blabels{bi,bj}];
               end
            end
         end
      end

      blabels = composed;
   end % for
   labels = blabels;
   return
end

%==========================================================================
% Expand Labels
%==========================================================================

function labels = Expand(list)
%
% EXPAND   Expand labels properly
%
   labels = list;
   if isempty(list)
      return
   end
   
   if ~iscell(list{1})
      return
   end

   [ml,nl] = size(list);
   labels = {};
   for (i=1:ml)
      row = {}; 
      for (j=1:nl)
         row = [row list{i,j}];
      end
      labels = [labels; row];
   end
   return
end

