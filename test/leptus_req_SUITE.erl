%% This file is part of leptus, and released under the MIT license.
%% See LICENSE for more information.

-module(leptus_req_SUITE).

-export([all/0]).
-export([param/1]).
-export([params/1]).
-export([qs/1]).
-export([qs_val/1]).
-export([uri/1]).
-export([version/1]).
-export([body/1]).
-export([body_raw/1]).
-export([body_qs/1]).
-export([header/1]).
-export([parse_header/1]).
-export([auth/1]).
-export([method/1]).


all() ->
    [
     param, params, qs, qs_val, uri, version, body, body_raw, body_qs,
     header, parse_header, auth, method
    ].

param(_) ->
    true = undefined =:= leptus_req:param(namez, req1()),
    <<"leptus">> = leptus_req:param(name, req1()),
    true = undefined =:= leptus_req:param(idz, req1()),
    <<"97dba1">> = leptus_req:param(id, req1()),
    undefined = leptus_req:param(id, req2()).

params(_) ->
    [{name, <<"leptus">>}, {id, <<"97dba1">>}] = leptus_req:params(req1()),
    [] = leptus_req:params(req2()).

qs(_) ->
    <<>> = leptus_req:qs(req1()),
    <<"q=123&b=456">> = leptus_req:qs(req2()).

qs_val(_) ->
    undefined = leptus_req:qs_val(<<"p">>, req1()),
    undefined = leptus_req:qs_val(<<"p">>, req2()),
    <<"123">> = leptus_req:qs_val(<<"q">>, req2()),
    <<"456">> = leptus_req:qs_val(<<"b">>, req2()).

uri(_) ->
    <<"/hello/leptus/97dba1">> = leptus_req:uri(req1()),
    <<"/hello/leptus/97dba1?q=123&b=456">> = leptus_req:uri(req2()).

version(_) ->
    'HTTP/1.1' = leptus_req:version(req1()),
    'HTTP/1.1' = leptus_req:version(req2()).

body(_) ->
    <<>> = leptus_req:body(req1()),
    <<"AAAAAAAAAAA">> = leptus_req:body(req3()),

    %% when content-type is application/json
    [
     {<<"firstname">>, <<"Sina">>},
     {<<"lastname">>, <<"Samavati">>}
    ] = leptus_req:body(req5()),

    %% when content-type is application/x-msgpack
    [
     {<<"abc">>, 123},
     {456, <<"def">>}
    ] = leptus_req:body(req7()).

body_raw(_) ->
    <<>> = leptus_req:body_raw(req1()),
    <<"AAAAAAAAAAA">> = leptus_req:body_raw(req3()),
    <<"{\"firstname\": \"Sina\","
      " \"lastname\": \"Samavati\"}">> = leptus_req:body_raw(req5()).

body_qs(_) ->
    [] = leptus_req:body_qs(req1()),
    [{<<"AAAAAAAAAAA">>, true}] = leptus_req:body_qs(req3()),
    [
     {<<"firstname">>, <<"Sina">>},
     {<<"lastname">>, <<"Samavati">>}
    ] = leptus_req:body_qs(req4()).

header(_) ->
    <<>> = leptus_req:header(<<"content-type">>, req1()),
    <<"localhost:8080">> = leptus_req:header(<<"host">>, req2()),
    <<"application/x-www-form-urlencoded">> =
        leptus_req:header(<<"content-type">>, req3()).

parse_header(_) ->
    <<>> = leptus_req:parse_header(<<"content-type">>, req1()),
    <<"localhost:8080">> = leptus_req:parse_header(<<"host">>, req2()),
    {
      <<"application">>, <<"x-www-form-urlencoded">>, []
    } = leptus_req:parse_header(<<"content-type">>, req3()),
    {
      <<"application">>, <<"json">>, []
    } = leptus_req:parse_header(<<"content-type">>, req5()).

auth(_) ->
    <<>> = leptus_req:auth(basic, req1()),
    <<>> = leptus_req:auth(basic, req3()),
    {<<"123">>, <<"456">>} = leptus_req:auth(basic, req5()),
    error = leptus_req:auth(basic, req6()).

method(_) ->
    <<"GET">> = leptus_req:method(req1()),
    <<"GET">> = leptus_req:method(req2()),
    <<"POST">> = leptus_req:method(req3()),
    <<"POST">> = leptus_req:method(req4()).


req1() ->
    {http_req, port, ranch_tcp, keepalive, pid, <<"GET">>,
     'HTTP/1.1',
     {{127,0,0,1}, 34273},
     <<"localhost">>, undefined, 8080, <<"/hello/leptus/97dba1">>, undefined,
     <<>>, undefined,
     [{name, <<"leptus">>}, {id, <<"97dba1">>}],
     [{<<"user-agent">>,
       <<"curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1"
         " zlib/1.2.3.4 libidn/1.23 librtmp/2.3">>},
      {<<"host">>, <<"localhost:8080">>},
      {<<"accept">>, <<"*/*">>}],
     [], undefined, [], waiting, undefined, <<>>, false, waiting, [], <<>>,
     undefined}.

req2() ->
    {http_req, port, ranch_tcp, keepalive, pid, <<"GET">>,
     'HTTP/1.1',
     {{127,0,0,1}, 34273},
     <<"localhost">>, undefined, 8080, <<"/hello/leptus/97dba1">>, undefined,
     <<"q=123&b=456">>, undefined, [],
     [{<<"user-agent">>,
       <<"curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1"
         " zlib/1.2.3.4 libidn/1.23 librtmp/2.3">>},
      {<<"host">>, <<"localhost:8080">>},
      {<<"accept">>, <<"*/*">>}],
     [], undefined, [], waiting, undefined, <<>>, false, waiting, [], <<>>,
     undefined}.

req3() ->
    {http_req, port, ranch_tcp, keepalive, pid, <<"POST">>,
     'HTTP/1.1',
     {{127,0,0,1},34372},
     <<"localhost">>, undefined, 8080, <<"/">>, undefined, <<>>, undefined,
     [], [{<<"user-agent">>,
           <<"curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1"
             " zlib/1.2.3.4 libidn/1.23 librtmp/2.3">>},
          {<<"host">>, <<"localhost:8080">>},
          {<<"accept">>, <<"*/*">>},
          {<<"content-length">>, <<"11">>},
          {<<"content-type">>, <<"application/x-www-form-urlencoded">>}],
     [], undefined, [], waiting, undefined, <<"AAAAAAAAAAA">>, false,
     waiting, [], <<>>, undefined}.

req4() ->
    {http_req, port, ranch_tcp, keepalive, pid, <<"POST">>,
     'HTTP/1.1',
     {{127,0,0,1},34372},
     <<"localhost">>, undefined, 8080, <<"/">>, undefined, <<>>, undefined,
     [], [{<<"user-agent">>,
           <<"curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1"
             " zlib/1.2.3.4 libidn/1.23 librtmp/2.3">>},
          {<<"host">>, <<"localhost:8080">>},
          {<<"accept">>, <<"*/*">>},
          {<<"content-length">>, <<"32">>},
          {<<"content-type">>, <<"application/x-www-form-urlencoded">>}],
     [], undefined, [], waiting, undefined,
     <<"firstname=Sina&lastname=Samavati">>, false, waiting, [], <<>>,
     undefined}.

req5() ->
    {http_req,port,ranch_tcp,keepalive,pid,<<"POST">>,
     'HTTP/1.1',
     {{127,0,0,1},33977},
     <<"localhost">>,undefined,8080,<<"/">>,undefined,<<>>,undefined,
     [],[{<<"authorization">>,<<"Basic MTIzOjQ1Ng==">>},
         {<<"user-agent">>,
          <<"curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1"
            "zlib/1.2.3.4 libidn/1.23 librtmp/2.3">>},
         {<<"host">>,<<"localhost:8080">>},
         {<<"accept">>,<<"*/*">>},
         {<<"content-type">>,<<"application/json">>},
         {<<"content-length">>,<<"45">>}],
     [],undefined,[],waiting,undefined,
     <<"{\"firstname\": \"Sina\", \"lastname\": \"Samavati\"}">>,
     false,waiting,[],<<>>,console_log}.

req6() ->
    {http_req,port,ranch_tcp,keepalive,pid,<<"POST">>,
     'HTTP/1.1',
     {{127,0,0,1},33977},
     <<"localhost">>,undefined,8080,<<"/">>,undefined,<<>>,undefined,
     [],[{<<"authorization">>,<<"Basic c2luYXdyb3RlX21lOg==">>},
         {<<"user-agent">>,
          <<"curl/7.22.0 (x86_64-pc-linux-gnu) libcurl/7.22.0 OpenSSL/1.0.1"
            "zlib/1.2.3.4 libidn/1.23 librtmp/2.3">>},
         {<<"host">>,<<"localhost:8080">>},
         {<<"accept">>,<<"*/*">>},
         {<<"content-type">>,<<"application/json">>},
         {<<"content-length">>,<<"45">>}],
     [],undefined,[],waiting,undefined,
     <<"{\"firstname\": \"Sina\", \"lastname\": \"Samavati\"}">>,
     false,waiting,[],<<>>,console_log}.

req7() ->
    {http_req,port,ranch_tcp,keepalive,pid,<<"POST">>,
     'HTTP/1.1',
     {{127,0,0,1},60773},
     <<"localhost">>,undefined,8080,<<"/msgpack">>,undefined,<<>>,
     undefined,[],
     [{<<"content-length">>,<<"13">>},
      {<<"host">>,<<"localhost:8080">>},
      {<<"user-agent">>,<<"Cow">>},
      {<<"content-type">>,<<"application/x-msgpack">>}],
     [],undefined,[],waiting,undefined,
     <<130,163,97,98,99,123,205,1,200,163,100,101,102>>,
     false,waiting,[],<<>>,console_log}.
