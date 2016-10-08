%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  
%  This file is part of Logtalk <http://logtalk.org/>  
%  Copyright 1998-2016 Paulo Moura <pmoura@logtalk.org>
%  
%  Licensed under the Apache License, Version 2.0 (the "License");
%  you may not use this file except in compliance with the License.
%  You may obtain a copy of the License at
%  
%      http://www.apache.org/licenses/LICENSE-2.0
%  
%  Unless required by applicable law or agreed to in writing, software
%  distributed under the License is distributed on an "AS IS" BASIS,
%  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%  See the License for the specific language governing permissions and
%  limitations under the License.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- object(simpsons,
	extends(familytree)).

	:- info([
		version is 1.0,
		author is 'Paulo Moura',
		date is 2015/09/23,
		comment is 'Simpsons family.'
	]).

	male(homer).
	male(bart).

	female(lisa).
	female(maggie).
	female(marge).

	parent(homer, bart).
	parent(homer, lisa).
	parent(homer, maggie).
	parent(marge, bart).
	parent(marge, lisa).
	parent(marge, maggie).

:- end_object.
