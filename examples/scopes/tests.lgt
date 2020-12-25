%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <https://logtalk.org/>
%  Copyright 1998-2021 Paulo Moura <pmoura@logtalk.org>
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
		version is 1:0:0,
		author is 'Paulo Moura',
		date is 2018-08-28,
		comment is 'Unit tests for the "scopes" example.'
	]).

	:- discontiguous([succeeds/1, throws/2]).

	cover(prototype).
	cover(descendant).

	succeeds(scopes_01) :-
		prototype::foo(Foo),
		Foo == 1.

	throws(scopes_02, error(permission_error(access,protected_predicate,bar/1),_)) :-
		prototype::bar(_).

	throws(scopes_03, error(permission_error(access,private_predicate,baz/1),_)) :-
		prototype::baz(_).

	throws(scopes_04, error(existence_error(predicate_declaration,(local)/1),_)) :-
		prototype::local(_).

	succeeds(scopes_05) :-
		descendant::p_foo(Foo),
		Foo == 2.

	succeeds(scopes_06) :-
		descendant::p_bar(Bar),
		Bar == 2.

	succeeds(scopes_07) :-
		descendant::p_baz(Baz),
		Baz == 2.

	succeeds(scopes_08) :-
		descendant::d_foo(Foo),
		Foo == 1.

	succeeds(scopes_09) :-
		descendant::d_bar(Bar),
		Bar == 1.

:- end_object.
