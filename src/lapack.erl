-module(lapack).
-export([svd/1,mmultiply/2]).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").
-endif.

-on_load(init/0).


init() ->
    SoName = case code:priv_dir(?MODULE) of
    {error, bad_name} ->
        case filelib:is_dir(filename:join(["..", "priv"])) of
        true ->
            filename:join(["..", "priv", "lapack_nif"]);
        false ->
            filename:join(["priv", "lapack_nif"])
        end;
    Dir ->
        filename:join(Dir, "lapack_nif")
    end,
    (catch erlang:load_nif(SoName, 0)),
    case erlang:system_info(otp_release) of
    "R13B03" -> true;
    _ -> ok
    end.

svd(_) -> exit(nif_library_not_loaded).
mmultiply(_,_) -> exit(nif_library_not_loaded).

-ifdef(TEST).

simple_test() ->
	A=[[1.0,2.0],[3.0,4.0]],
	B=[[1.0,2.0,3.0],[4.0,5.0,6.0]],
	?assert(lapack:mmultiply(A,B)==[[9.0,12.0,15.0],[19.0,26.0,33.0]]).

-endif.
