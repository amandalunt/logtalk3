%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <http://logtalk.org/>  
%  Copyright (c) 1998-2014 Paulo Moura <pmoura@logtalk.org>
%
%  This program is free software: you can redistribute it and/or modify
%  it under the terms of the GNU General Public License as published by
%  the Free Software Foundation, either version 3 of the License, or
%  (at your option) any later version.
%  
%  This program is distributed in the hope that it will be useful,
%  but WITHOUT ANY WARRANTY; without even the implied warranty of
%  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%  GNU General Public License for more details.
%  
%  You should have received a copy of the GNU General Public License
%  along with this program.  If not, see <http://www.gnu.org/licenses/>.
%  
%  Additional licensing terms apply per Section 7 of the GNU General
%  Public License 3. Consult the `LICENSE.txt` file for details.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


:- object(xref_diagram(Format),
	extends(entity_diagram(Format))).

	:- info([
		version is 2.0,
		author is 'Paulo Moura',
		date is 2014/02/05,
		comment is 'Predicates for generating predicate call cross-referencing diagrams.',
		parnames is ['Format']
	]).

	:- public(entity/2).
	:- mode(entity(+atom, +list(compound)), one).
	:- info(entity/2, [
		comment is 'Creates a diagram for a single entity using the specified options.',
		argnames is ['Entity', 'Options']
	]).

	:- public(entity/1).
	:- mode(entity(+atom), one).
	:- info(entity/1, [
		comment is 'Creates a diagram for a single entity using default options.',
		argnames is ['Entity']
	]).

	:- private(external_predicate_/1).
	:- dynamic(external_predicate_/1).

	entity(Entity, UserOptions) :-
		entity_kind(Entity, Kind, Name),
		atom_concat(Name, '_', Identifier0),
		atom_concat(Identifier0, Kind, Identifier),
		^^format_object(Format),
		^^merge_options(UserOptions, Options),
		reset,
		^^output_file_path(Identifier, Options, Format, OutputPath),
		open(OutputPath, write, Stream, [alias(output_file)]),
		Format::file_header(output_file, Identifier, Options),
		entity_property(Kind, Entity, file(Basename, Directory)),
		atom_concat(Directory, Basename, Path),
		^^linking_options(Path, Options, GraphOptions),
		Format::graph_header(output_file, Identifier, Name, entity, GraphOptions),
		process(Kind, Entity, Options),
		output_externals(Options),
		^^output_edges(Options),
		Format::graph_footer(output_file, Identifier, Name, entity, GraphOptions),
		Format::file_footer(output_file, Identifier, Options),
		close(Stream).

	entity(Entity) :-
		entity(Entity, []).

	entity_kind(Entity, Kind, Name) :-
		(	current_object(Entity) ->
			Kind = object
		;	current_category(Entity) ->
			Kind = category
		;	% current_protocol(Entity),
			Kind = protocol
		),
		^^ground_entity_identifier(Kind, Entity, Name).

	process(Kind, Entity, Options) :-
		entity_property(Kind, Entity, defines(Caller, Properties)),
		\+ member(auxiliary, Properties),
		^^output_node(Caller, Caller, [], predicate, Options),
		fail.
	process(Kind, Entity, Options) :-
		calls_local_predicate(Kind, Entity, Caller, Callee),
		\+ ^^edge(Caller, Callee, [calls], calls_predicate, _),
		^^save_edge(Caller, Callee, [calls], calls_predicate, [tooltip(calls)| Options]),
		fail.
	process(Kind, Entity, Options) :-
		calls_external_predicate(Kind, Entity, Caller, Callee),
		remember_external_predicate(Callee),
		\+ ^^edge(Caller, Callee, [calls], calls_predicate, _),
		^^save_edge(Caller, Callee, [calls], calls_predicate, [tooltip(calls)| Options]),
		fail.
	process(_, _, _).

	calls_local_predicate(Kind, Entity, Caller, Callee) :-
		entity_property(Kind, Entity, calls(Callee, Properties)),
		Callee \= _::_,
		Callee \= ':'(_, _),
		once(member(caller(Caller), Properties)).

	calls_external_predicate(Kind, Entity, Caller, Object::Callee) :-
		entity_property(Kind, Entity, calls(Object::Callee, Properties)),
		nonvar(Object),
		once(member(caller(Caller), Properties)).
	calls_external_predicate(Kind, Entity, Caller, ':'(Module,Callee)) :-
		entity_property(Kind, Entity, calls(':'(Module,Callee), Properties)),
		nonvar(Module),
		once(member(caller(Caller), Properties)).

	entity_property(object, Entity, Property) :-
		object_property(Entity, Property).
	entity_property(category, Entity, Property) :-
		category_property(Entity, Property).
	entity_property(protocol, Entity, Property) :-
		protocol_property(Entity, Property).

	reset :-
		retractall(external_predicate_(_)).

	remember_external_predicate(Predicate) :-
		(	external_predicate_(Predicate) ->
			true
		;	assertz(external_predicate_(Predicate))
		).

	output_externals(Options) :-
		^^format_object(Format),
		Format::graph_header(output_file, other, '(external predicates)', external, [tooltip('(external predicates)')| Options]),
		retract(external_predicate_(Object::Predicate)),
		^^ground_entity_identifier(object, Object, Name),
		^^output_node(Name::Predicate, Name::Predicate, [], external_predicate, Options),
		fail.
	output_externals(Options) :-
		retract(external_predicate_(':'(Module,Predicate))),
		^^output_node(':'(Module,Predicate), ':'(Module,Predicate), [], external_predicate, Options),
		fail.
	output_externals(Options) :-
		^^format_object(Format),
		Format::graph_footer(output_file, other, '(external predicates)', external, [tooltip('(external predicates)')| Options]).

	% by default, diagram title is empty:
	default_option(title('')).
	% by default, print current date:
	default_option(date(true)).
	% by default, print entity public predicates:
	default_option(interface(true)).
	% by default, print file labels:
	default_option(file_labels(true)).
	% by default, don't write inheritance links:
	default_option(inheritance_relations(false)).
	% by default, don't write provide links:
	default_option(provide_relations(false)).
	% by default, don't write cross-referencing links:
	default_option(xref_relations(false)).
	% by default, print entity relation labels:
	default_option(relation_labels(true)).
	% by default, write cross-referencing calls:
	default_option(xref_calls(true)).
	% by default, write diagram to the current directory:
	default_option(output_directory('./')).
	% by default, don't exclude any source files:
	default_option(exclude_files([])).
	% by default, don't exclude any library sub-directories:
	default_option(exclude_libraries([])).
	% by default, don't exclude any entities:
	default_option(exclude_entities([])).
	% by default, don't generate cluster URLs:
	default_option(url_protocol('')).
	% by default, don't omit a path prefix when printing paths:
	default_option(omit_path_prefix('')).

	diagram_name_suffix('_xref_diagram').

	member(Option, [Option| _]) :-
		!.
	member(Option, [_| Options]) :-
		member(Option, Options).

:- end_object.



:- object(xref_diagram,
	extends(xref_diagram(dot))).

	:- info([
		version is 2.0,
		author is 'Paulo Moura',
		date is 2014/01/01,
		comment is 'Predicates for generating predicate call cross-referencing diagrams in DOT format.'
	]).

:- end_object.
