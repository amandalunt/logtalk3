________________________________________________________________________

This file is part of Logtalk <https://logtalk.org/>  
Copyright 1998-2022 Paulo Moura <pmoura@logtalk.org>  
SPDX-License-Identifier: Apache-2.0

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
________________________________________________________________________


`tutor`
=======

This tool adds explanations and suggestions to selected compiler warning
and error messages. It's most useful for new users not yet familiar with
the compiler and runtime warning and error messages.


API documentation
-----------------

This tool API documentation is available at:

[../../docs/library_index.html#tutor](../../docs/library_index.html#tutor)


Loading
-------

This tool can be loaded using the query:

	| ?- logtalk_load(tutor(loader)).


Usage
-----

Simply load the tool at startup (e.g. from a settings file).
