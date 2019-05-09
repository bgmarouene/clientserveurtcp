-module(clientserveurtcp).
-compile(export_all).
 
start_server() ->
    Pid = spawn_link(fun() ->
        {ok, Listen} = gen_tcp:listen(4000, [binary, {active, false}]),
        spawn(fun() -> acceptor(Listen) end),
        timer:sleep(infinity)
        end),
    {ok, Pid}.

acceptor(ListenSocket) ->
    {ok, Socket} = gen_tcp:accept(ListenSocket),
    spawn(fun() -> acceptor(ListenSocket) end),
    handle(Socket).

handle(Socket) ->
    inet:setopts(Socket, [{active, once}]),
    receive
        {tcp, Socket, Msg} ->
            gen_tcp:send(Socket, Msg),
        handle(Socket)
    end.
