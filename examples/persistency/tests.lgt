%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <https://logtalk.org/>
%  Copyright 1998-2022 Paulo Moura <pmoura@logtalk.org>
%  SPDX-License-Identifier: Apache-2.0
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


:- object(tests,
	extends(lgtunit)).

	:- info([
		version is 1:1:1,
		author is 'Paulo Moura',
		date is 2022-02-13,
		comment is 'Unit tests for the "persistency" example.'
	]).

	:- uses(persistency, [
		add/1, state/1, save/0, reset/0
	]).

	cover(persistency).

	test(persistency_1) :-
		add(a),
		add(b),
		add(c),
		setof(Term, state(Term), Terms),
		ground(Terms), Terms = [a,b,c| _].

	test(persistency_2) :-
		save.

	test(persistency_3) :-
		reset.

	cleanup :-
		this(This),
		object_property(This, file(_,Directory)),
		atom_concat(Directory, 'state.pl', File),
		(	os::file_exists(File) ->
			os::delete_file(File)
		;	true
		).

:- end_object.
