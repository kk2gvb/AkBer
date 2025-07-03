-module(rep).
-export([main/0, loop/2]).

main() ->
    application:start(chumak),
    {ok, Sock} = chumak:socket(rep),
    {ok, _} = chumak:bind(Sock, tcp, "0.0.0.0", 5000),
    loop(Sock, 10),
    gen_server:stop(Sock).

loop(_, 0) ->
    ok;

loop(Sock, Count) when Count > 0 ->
    {ok, Message} = chumak:recv(Sock),
    io:format("Полученно сообщение: ~p~n", [Message]),
    chumak:send(Sock, <<"Hello, REQ">>),
    loop(Sock, Count - 1).
