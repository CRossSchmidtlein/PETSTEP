function tf = isvar_cerr(name, field)
%|function tf = isvar_cerr(name)
%|
%| determine if "name" is a variable in the caller's workspace.
%|
%| if argument is of the form 'name.field' or 'name.field1.field2' etc.
%| then this uses isfield(st, 'field') recursively as needed
%|
%| From the Image Reconstruction Tool Box (irt) 
%| http://web.eecs.umich.edu/~fessler/code/
%| Modified for use in CERR, CRS
%|
%| Copyright 2000-01-01, Jeff Fessler, University of Michigan
%| modified 2010-04-21 to use 'exist' and 'isfield'

if nargin < 1, help(mfilename), error(mfilename), end

dots = strfind(name, '.'); % look for any field references

if isempty(dots)
	base = name;
else
	base = name(1:dots(1)-1);
	tail = name((dots(1)+1):end);
end

str = sprintf('exist(''%s'', ''var'');', base);
tf = evalin('caller', str);

while tf && length(dots)
	if length(dots) == 1
		str = sprintf('isfield(%s, ''%s'');', base, tail);
		tf = tf & evalin('caller', str);
		return
	else
		dots = dots(2:end) - dots(1);
		next = tail(1:dots(1)-1);
		str = sprintf('isfield(%s, ''%s'');', base, next);
		tf = tf & evalin('caller', str);
		base = [base '.' next];
		tail = tail((dots(1)+1):end);
	end
end

%tf = true;
%evalin('caller', [name ';'], 'tf=false;') % old way
