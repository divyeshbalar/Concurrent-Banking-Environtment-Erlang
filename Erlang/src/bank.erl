%% @author divyesh
%% @doc @todo Add description to bank.
%% /home/divyesh/eclipse-workspace/BankingProject/src/
%% 


-module(bank).
%% ====================================================================
%% API functions
%% ====================================================================
-export([read_bank_data/0, readBankTuple/0, write_to_file/2, get_loan_request/2]).


-import(io,[fwrite/1,fwrite/2]).

%% ====================================================================
%% Internal functions
%% ====================================================================


read_bank_data() ->
	{ok, BankList} = file:consult("bank.txt"),
	BankMap = maps:from_list(BankList),
	io:format("~w", [BankMap]),
	BankMap.

readBankTuple() -> % return list of tuples
	{ok, BankList} = file:consult("bank.txt"),
	io:format("~nTotal Bank Fund is = ~w~n", [BankList]),
	BankList.

%%Customer ask Bank for loan amount 
%% approveLoan(Cname) ->
%% 	receive
%% 		{_} ->
%% 			io:format("Stop at Bank empty recieve block");
%% 		{Bname, Amount, Sender} ->
%% 			io:format("~n ~w has requested ~w$ from ~w bank~n", [Cname, Amount, Bname]),
%% 			timer:sleep(1000),
%% 			Banks = read_bank_data(),
%% 			%%io:format("~n Is Random Amount ~w ~n",[Amount]),
%% 			BankVal = maps:get(Bname, Banks),
%% 			if
%% 				  	(Amount < BankVal) or (Amount == BankVal) ->
%% 						UpdatedFund = maps:get(Bname, Banks) - Amount,
%% 						{ok, File} = file:open("bank.txt",write),
%% 						io:format("~w is updated Funds in Bank", [UpdatedFund]),
%% 						%% writing to common bank file after update
%% 						HG = cust:updateFunds(Cname, Amount, self(), Sender),
%% 						BB = write_to_file(File, maps:put(Bname, UpdatedFund, Banks)),
%% 						timer:sleep(1000),
%% 						Sender ! {approved, Cname, Bname, Amount};% sender here is of main start method
%% 						
%% 					true -> 
%% 						if
%% 							BankVal == 0 ->
%% 								R = maps:remove(Bname, Banks),
%% 								{ok, File} = file:open("bank.txt",write),
%% 								%% writing to common bank file after update
%% 								write_to_file(File, R),
%% 								Sender ! {rejected, Cname, Bname, Amount};
%% 							true -> 
%% 								Sender ! {rejected, Cname, Bname, Amount}
%% 						end
%% 				  end
%% 		end.
%% 	
	
	
	



write_to_file(File, Banks) ->
	Range = maps:keys(Banks),
	lists:foreach(fun(N) ->
		Val = maps:get(N, Banks),
		%%io:format("Writing into file"),
		io:fwrite(File,"{~w,~w}.~n",[N,Val])
    end, Range),
	true.

get_loan_request(BankName, AvailFund) ->
	receive
    {CustName,RequiredLoan}->
	 io:fwrite("~p has requested ~p$ from ~p bank~n",[CustName,RequiredLoan,BankName]),
      CustID = whereis(CustName),
      if
        (AvailFund==0) or (AvailFund<RequiredLoan) ->
	        CustID ! {BankName,"Rejected"},
	        %%fwrite("~p has no enough fund of ~p$ for Customer ~p.~n",[BankName,RequiredLoan,CustName]),
	        get_loan_request(BankName,AvailFund);
        true ->
	        CustID ! {BankName,"Approved"},
	        %%fwrite("~p has approved loan of ~p$ for ~p.~n",[BankName,RequiredLoan,CustName]),
	        get_loan_request(BankName, AvailFund-RequiredLoan)
      end
	%%Every two second read funds
	after 2000 ->  io:fwrite("Bank ~p got ~p$ in Available Fund.~n",[BankName,AvailFund])
    end.

