-module(rep).
-export([main/0]).

main() ->
    %FileName = "/tmp/AkBer.sock",
    %AbstractPath = <<0, (list_to_binary(FileName))/binary>>,
    application:start(chumak),
    {ok, Sock} = chumak:socket(rep),
    {ok, _} = chumak:bind(Sock, tcp, "0.0.0.0", 5001),
    loop(Sock).

loop(Sock) ->
    {ok, _Message} = chumak:recv(Sock),
    chumak:send(Sock, <<"Huy">>),
    loop(Sock).
