%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%  This file is part of Logtalk <https://logtalk.org/>
%  Copyright 1998-2019 Paulo Moura <pmoura@logtalk.org>
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


:- object(directory_load_diagram(Format),
	imports(directory_diagram(Format))).

	:- info([
		version is 2.8,
		author is 'Paulo Moura',
		date is 2019/04/06,
		comment is 'Predicates for generating directory loading dependency diagrams.',
		parnames is ['Format'],
		see_also is [directory_dependency_diagram(_), file_dependency_diagram(_)]
	]).

	:- uses(list, [
		member/2, memberchk/2
	]).

	% first, output the directory node
	output_library(_, Directory, Options) :-
		^^add_link_options(Directory, Options, LinkingOptions),
		^^omit_path_prefix(Directory, Options, Relative),
		^^add_directory_documentation_url(logtalk, LinkingOptions, Relative, NodeOptions0),
		(	logtalk::loaded_file_property(File, directory(Directory)),
			(	logtalk::loaded_file_property(File, object(_))
			;	logtalk::loaded_file_property(File, protocol(_))
			;	logtalk::loaded_file_property(File, category(_))
			) ->
			entity_diagram::diagram_name_suffix(Suffix),
			^^add_node_zoom_option(Directory, Suffix, Options, NodeOptions0, NodeOptions)
		;	% no entities for this directory; diagram empty
			NodeOptions = NodeOptions0
		),
		(	member(directory_paths(true), Options) ->
			^^output_node(Relative, Relative, directory, [Relative], directory, NodeOptions)
		;	^^output_node(Relative, Relative, directory, [], directory, NodeOptions)
		),
		^^remember_included_directory(Directory),
		fail.
	% second, output edges for all directories loaded by files in this directory
	output_library(_, Directory, Options) :-
		% any Logtalk or Prolog directory file may load other files
		(	logtalk::loaded_file_property(File, directory(Directory))
		;	modules_diagram_support::loaded_file_property(File, directory(Directory))
		),
		% look for a file in another directory that have this file as parent
		(	memberchk(exclude_directories(ExcludedDirectories), Options),
			logtalk::loaded_file_property(Other, parent(File)),
			logtalk::loaded_file_property(Other, directory(OtherDirectory)),
			OtherDirectory \== Directory,
			\+ member(OtherDirectory, ExcludedDirectories),
			logtalk::loaded_file_property(Other, directory(OtherDirectory))
		;	modules_diagram_support::loaded_file_property(Other, parent(File)),
			modules_diagram_support::loaded_file_property(Other, directory(OtherDirectory)),
			OtherDirectory \== Directory,
			% not a Logtalk generated intermediate Prolog file
			\+ logtalk::loaded_file_property(_, target(Other)),
			writeq(loaded_file_property(Other, parent(File))-OtherDirectory), nl
		),
		^^omit_path_prefix(Directory, Options, Relative),
		^^omit_path_prefix(OtherDirectory, Options, OtherRelative),
		% edge not previously recorded
		\+ ^^edge(Relative, OtherRelative, _, _, _),
		(	logtalk::loaded_file_property(Other, directory(OtherDirectory)) ->
			^^remember_referenced_logtalk_directory(OtherDirectory)
		;	% Prolog directory module
			^^remember_referenced_prolog_directory(OtherDirectory)
		),
		^^save_edge(Relative, OtherRelative, [loads], loads_directory, [tooltip(loads)| Options]),
		fail.
	output_library(_, _, _).

	% by default, diagram layout is top to bottom:
	default_option(layout(top_to_bottom)).
	% by default, diagram title is empty:
	default_option(title('')).
	% by default, print current date:
	default_option(date(true)).
	% by default, don't generate cluster, file, and entity URLs:
	default_option(url_prefixes('', '')).
	% by default, don't omit any path prefixes when printing paths:
	default_option(omit_path_prefixes([])).
	% by default, don't print directory paths:
	default_option(directory_paths(false)).
	% by default, print relation labels:
	default_option(relation_labels(true)).
	% by default, print node type captions
	default_option(node_type_captions(true)).
	% by default, write diagram to the current directory:
	default_option(output_directory('./')).
	% by default, don't exclude any directories:
	default_option(exclude_directories([])).
	% by default, don't exclude any source files:
	default_option(exclude_files([])).
	% by default, use a 'directory_index.html' suffix for entity documentation URLs:
	default_option(entity_url_suffix_target('directory_index.html', '#')).
	% by default, don't zooming into libraries and entities:
	default_option(zoom(false)).
	% by default, use a '.svg' extension for zoom linked diagrams
	default_option(zoom_url_suffix('.svg')).

	diagram_name_suffix('_directory_load_diagram').

:- end_object.



:- object(directory_load_diagram,
	extends(directory_load_diagram(dot))).

	:- info([
		version is 1.0,
		author is 'Paulo Moura',
		date is 2019/04/07,
		comment is 'Predicates for generating directory loading dependency diagrams in DOT format.',
		see_also is [directory_dependency_diagram, file_dependency_diagram]
	]).

:- end_object.
