%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  This file is part of Logtalk <http://logtalk.org/>
%  
%  Logtalk is free software. You can redistribute it and/or modify it under
%  the terms of the FSF GNU General Public License 3  (plus some additional
%  terms per section 7).        Consult the `LICENSE.txt` file for details.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% conflict between uses/2 directive and a predicate definition

:-object(usesconflict).

	:- uses(list, [member/2]).

	member(H, [H| _]).		% an object (or category) cannot define a
	member(H, [_| T]) :-	% predicate referenced on a uses/2 directive
		member(H, T).

:- end_object.
