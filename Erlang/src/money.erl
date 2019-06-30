%% @author divyesh
%% @doc @todo Add description to money.
%% /home/divyesh/eclipse-workspace/BankingProject/src/


-module(money).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0]).



%% ====================================================================
%% Internal functions
%% ====================================================================

start() ->
	CustData = cust:readCustTuple(),%list of tuples
	BankData = bank:readBankTuple(),
	%%io:format("~n~w is List of Tuple or X", [BankData]),
	CustMap = maps:from_list(CustData),
	BankMap = maps:from_list(BankData),
	BankRange = maps:keys(BankMap), %%list of bank
	CustRange = maps:keys(CustMap),
	%%io:format("~n ~w is CustMap ~n ~w is BankMap ~n ~w is Tuple~n ~w is CustRamge",[CustMap, BankMap, lists:keyfind(frank, 1, CustData), CustRange]),
	
	lists:foreach(fun(N) ->
		PPid = spawn(bank, get_loan_request, [N, maps:get(N, BankMap)]), %bank name and BankAvailFund
		register(N,PPid)		
		%%io:format("~n ~w ====> ~w ~n", [N, PPid])
    end, BankRange),
	
	
	
	lists:foreach(fun(N) ->
		CustTuple = lists:keyfind(N, 1, CustData),
		%%io:format("~n ~w = is tuple",[CustTuple]),
		PPid = spawn(cust, createCustSpawn, [N, maps:get(N, CustMap),BankRange,CustTuple, self()]), %cust name and requiredFund and List of available Banks
		register(N,PPid)		
		%%io:format("~n ~w ====> ~w ~n", [N, PPid])
    end, CustRange),
	
	listening(),
	timer:sleep(10000).

listening()->
	receive
		{BankName,"Approved", CustName, RequiredAmount}->
			io:format("~p has approved loan of ~p$ for ~p.~n",[BankName,RequiredAmount,CustName]),
		listening();
		{BankName,"Rejected", CustName, RequiredAmount} -> 
			io:format("~p has no enough fund of ~p$ for Customer ~p.~n",[BankName,RequiredAmount,CustName]),
			listening();
		{CustName,RemainingAmt,RequiredAmount,"Unsuccessful"} ->
			io:format("~p managed to get ~p$ of entire loan amount and missing ~p$.~n",[CustName,RemainingAmt,RequiredAmount]),
			listening();
		{"Successful",CustName,Amt} ->
			io:format("----------------~p got complete loan ~p$-----------------~n",[CustName, Amt]),
			listening()
	
	after 5000 -> io:format("Done I guess")	
	end.

