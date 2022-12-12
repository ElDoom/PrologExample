% simple Career Selector Example
% @author David Lopez Barcenas
% @date 12/12/2022

% This program illustrates a simple matcher algorithm, that lines up people and their attributes with jobs that
% might suit them.  
% It uses attribute-value lists and recursive list predicates to allow a very flexible means for representing
% job criteria.
 

% How to run the code after the file has been loaded:
% 
% ?- main.
% Are you practical (yes/no) yes
% Are you social (yes/no) yes
% You should be a politician
% true;
% You should be a nothing
% true.
% 
% ?- 

% Program can load different routines, facts, or extended knowledge base from external files using the next
% functions

%:- ensure_loaded(list).
%:- import(list).

% The main predicate - get the client job attributes, find the job for them and tell them


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
main :-
   get_client_attributes(CLIENT_ATTRIBUTES),
   find_job(JOB, CLIENT_ATTRIBUTES),
   write('You should be a '), write(JOB), nl.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% The tedious bit about finding the attributes, questions/1 has a list of structures of the form ATTRIBUTE - PROMPT.
% These will be used to ask the user the question and get a value for the attribute.

% Note on operators: the '-' in ATTR-PROMPT is just a Prolog operator.  It is just a structure
% Operators like this are often confusing to new Prolog users, because they seem more significant than
% they are.  
% We could have written the program as: attr_prompt_pair(practical, $Are you...$).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
questions([
   practical - 'Are you practical (yes/no/maybe) ',
   social - 'Are you social (yes/no/maybe) ',
   artistic - 'Are you artistic (yes/no/maybe) ',
   enterprising - 'Are you enterprising (yes/no/maybe) ']).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% pick up the question list, and ask the client each, getting a list of client's attibutes in return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
get_client_attributes(CLIENT_ATTRIBUTES) :-
   questions(QUESTIONS),
   ask_client(QUESTIONS, CLIENT_ATTRIBUTES).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% recursive loop to ask each question and store the answer in the output list.  
% The output list will be a list of ATTRIBUTE = VALUE pairs.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ask_client([], []).
ask_client([ATTR-PROMPT|QUESTIONS], [ATTR = ANS|CLIENT_ATTRIBUTES]) :- 
   write(PROMPT), read_string(user_input, "\n", "\t", End, STRING_ANS),
   term_string( ANS, STRING_ANS),
   ask_client(QUESTIONS, CLIENT_ATTRIBUTES).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% THE KNOWLEDGE BASE 
% Here's the jobs the system knows about, and for each we attach a list of attributes and values using
% the '='/2 operator.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
job('computer scientist', [practical = yes, social = no, artistic = no, enterprising = maybe]).
job('politician', [practical = yes, social = yes, artistic = no, enterprising = yes]).
job('actor', [social = yes, practical = no, artistic = yes, enterprising = maybe]).
job('animator', [social = yes, practical = no, artistic = yes, enterprising = maybe]).
job('game developer', [practical = yes, social = maybe, artistic = yes, enterprising = maybe]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Here we have a patter matcher which looks for jobs that match the attributes of the client.  
% We take each job, see if it fits the client, Prolog succees if it does, Prolog backtracks to the next job if
% it doesn't.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
find_job(JOB, CLIENT_ATTRIBUTES) :-
   job(JOB, JOB_ATTRIBUTES),
   match(CLIENT_ATTRIBUTES, JOB_ATTRIBUTES).
find_job(nothing, _).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% using member, to check each of the attribute value pairs of the client to see if that attr=val pair is in the 
% client.  If they all are, we have a match.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
member(A, [A|_]).
member(A, [_|Z]) :-
   member(A, Z).

match([], _).
match([ATTR = VALUE| AVS], LIST) :-
   member(ATTR=VALUE, LIST),
   match(AVS, LIST).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% the point being its very easy to write a pattern-matcher that compares things.
% The attribute value pair lists are a very flexible way to represent the knowledge and can be easily extended.
% The match/2 predicate can be expanded to include more sophisticated matching, so that whatever intelligence you 
% wanted to add to the system can be added.



%01 main :- get_client_attributes(CLIENT_ATTRIBUTES), find_job(JOB, CLIENT_ATTRIBUTES), write('You should be a '), write(JOB), nl.
%02 questions([ practical - 'Are you practical (yes/no/maybe) ', social - 'Are you social (yes/no/maybe) ', artistic - 'Are you artistic (yes/no/maybe) ', enterprising - 'Are you enterprising (yes/no/maybe) ']).
%03 get_client_attributes(CLIENT_ATTRIBUTES) :- questions(QUESTIONS), ask_client(QUESTIONS, CLIENT_ATTRIBUTES).
%04 ask_client([], []).
%05 ask_client([ATTR-PROMPT|QUESTIONS], [ATTR = ANS|CLIENT_ATTRIBUTES]) :-  write(PROMPT), read_string(user_input, "\n", "\t", End, STRING_ANS), term_string( ANS, STRING_ANS), ask_client(QUESTIONS, CLIENT_ATTRIBUTES).
%06 job('computer scientist', [practical = yes, social = no, artistic = no, enterprising = maybe]).
%07 job('politician', [practical = yes, social = yes, artistic = no, enterprising = yes]).
%08 job('actor', [social = yes, practical = no, artistic = yes, enterprising = maybe]).
%09 job('game developer', [practical = yes, social = maybe, artistic = yes, enterprising = maybe]).
%10 job('animator', [social = yes, practical = no, artistic = yes, enterprising = maybe]).
%11 find_job(JOB, CLIENT_ATTRIBUTES) :- job(JOB, JOB_ATTRIBUTES), match(CLIENT_ATTRIBUTES, JOB_ATTRIBUTES).
%12 find_job(nothing, _).
%13 member(A, [A|_]).
%14 member(A, [_|Z]) :- member(A, Z).
%15 match([], _).
%16 match([ATTR = VALUE| AVS], LIST) :- member(ATTR=VALUE, LIST), match(AVS, LIST).
