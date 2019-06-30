%% @author divyesh
%% @doc @todo Add description to cust.
%% /home/divyesh/eclipse-workspace/BankingProject/src/

-module(cust).

%% ====================================================================
%% API functions
%% ====================================================================
-export([get_cust_data/0, write_to_file/2, readCustTuple/0, createCustSpawn/5, feedback/7]).



%% ====================================================================
%% Internal functions
%% ====================================================================

createCustSpawn(CustName, RequiredAmount, BankList, CustTuple, Master) ->
	%%io:format("~n Spwan created for ~w ",[CustName]),
	timer:sleep(10),
	if
    ((RequiredAmount>50) and (length(BankList)>0)) ->
      RandomAmt=rand:uniform(50),
	  	%%io:format("~nInside Req > 50 and length > 0 line 24 Cust ~w~n",[RandomAmt]),
		%%io:format("~nInside Req > 50 and length > 0 line 25 Cust ~w is BankList ~n",[BankList]),
      Bno = rand:uniform(length(BankList)),%%getting index number for random bank
      BankName=lists:nth(Bno,BankList),
	  %%io:format("~nBeforeCalling FeedBack line 28 Cust~n"),
      cust:feedback(RandomAmt,RequiredAmount,CustName,BankList,BankName,CustTuple, Master);
	
    ((RequiredAmount =< 50) and (0<length(BankList))and (RequiredAmount>0)) ->
	  RandomAmt=rand:uniform(RequiredAmount),
	  %%io:format("~nInside Req <= 50 and length < 0 line 33 Cust ~w ~n",[RandomAmt]),
      Bno = rand:uniform(length(BankList)),
      BankName=lists:nth(Bno,BankList),
	  %%io:format("~nBeforeCalling FeedBack line 33 Cust~n"),
      cust:feedback(RandomAmt,RequiredAmount,CustName,BankList,BankName,CustTuple, Master);
    
	((RequiredAmount >0) and (length(BankList)==0)) ->
		Master ! {CustName,element(2,CustTuple)-RequiredAmount,RequiredAmount,"Unsuccessful"};
    	%%io:fwrite("~p managed to get ~p$ of entire loan amount and missing ~p$.~n",[CustName,element(2,CustTuple)-RequiredAmount,RequiredAmount]);
   
	RequiredAmount==0 ->
    	Master ! {"Successful",CustName,element(2,CustTuple)};
	%io:fwrite("----------------~p got complete loan ~p$-----------------~n",[CustName,element(2,CustTuple)]);
    true -> true
	end.

feedback(RandomAmt,RequiredAmount,CustName,BankList,BankName,CustTuple, Master) ->
  %%io:format("~nFeedBack is called line 45 Cust~n"),
  Baap= whereis(BankName),
  %%io:fwrite("~p has requested ~p$ from ~p bank~n",[CustName,RandomAmt,BankName]),
  Baap ! {CustName,RandomAmt},
  %%io:format("----------------~n ~w ! ~w, ~w--------------- ~n",[Baap, CustName, RandomAmt]),
  receive
    {BankName,"Approved"}->
		Master ! {BankName,"Approved",CustName,RandomAmt},
      createCustSpawn(CustName, RequiredAmount-RandomAmt, BankList, CustTuple, Master);
    {BankName,"Rejected"}->
		Master ! {BankName,"Rejected", CustName, RandomAmt},
      createCustSpawn(CustName, RequiredAmount, lists:delete(BankName,BankList), CustTuple, Master)
  after 5000->
    io:fwrite("~p got no respond from ~p | Maybe its holiday.~n",[CustName,BankName])
  end.



get_cust_data() ->
	%% H = ok CustList = real data
	{H, CustList} = file:consult("customer.txt"),
	CustMap = maps:from_list(CustList),
	io:format("~w", [CustMap]),
	CustMap.

readCustTuple() ->
	{H, CustList} = file:consult("customer.txt"),
	io:format("~n Total Customers and requirements of each is = ~w~n", [CustList]),
	CustList.


%% updateFunds(Cname, Amount, Sender, Master) ->
%% 	Custs = get_cust_data(),
%% 	CustVal = maps:get(Cname, Custs),
%% 	TempFund = CustVal - Amount,
%% 	%%io:format("~n Inside Update Customer fund PId is ~w(it should be of ~w) ",[Sender, Cname]),
%% 	TempSpaw = spawn(money, contCalling, []),
%% 	if
%% 		(TempFund < 0) or (TempFund == 0) ->
%% 			%%io:format("~n inside updateFund for customer TempFund < 0  and calling TempSpaw for contcalling ~w ~n",[TempSpaw]),
%% 			TempSpaw ! {Cname, Custs, Sender, Master};
%% 		true -> 
%% 			{ok, File} = file:open("customer.txt",write),
%% 			GG = write_to_file(File, maps:put(Cname, TempFund, Custs)),
%% 			Custs1 = get_cust_data(),
%% 			%%io:format("~n inside updateFund for customer ===TempFund > 0===  and calling TempSpaw for contcalling ~w ~n",[TempSpaw]),
%% 			TempSpaw ! {Cname, Custs1, Sender, Master}
%% 	end.
	
	%%io:format("Customer File Updated Successfully for ~w of amount ~w",[Cname, TempFund]).
	
	

write_to_file(File, Custs) ->
	Range = maps:keys(Custs),
	lists:foreach(fun(N) ->
		Val = maps:get(N, Custs),
		%%io:format("Writing into file"),
		io:fwrite(File,"{~w,~w}.~n",[N,Val])
    end, Range),
	true.



