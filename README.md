# Concurrent-Banking-Environtment-Erlang
It multiple banks and multiple clients loan request and approval environment by creating individual thread 
for individual entities. 

Folder Structure:
		> ebin - This folder contains the .beam of source
		> src - This folder include Erlang code to simulate loan approval scenario between banks and customer
    
Instruction to Run the code
	
	> Erlang
		> Compile the given .erl files 
		> Add Data files "bank.txt" and "customer.txt" in the same folder as .beam and .erl files are. 
		> call start() method of money.erl module "money:start()."
    
    
bank.txt:
  {td,500}.
  {bmo,520}.
  {sc,60}.
  
customer.txt:
  {divyesh,650}.
  {frank,55}.
  {neysa,100}.
  
  
  -----------------------------------For More Detail Read Further---------------------
  
objective	is	to	model	a	simple banking environment.	Specifically,	you	will	be	given	a	small
number of	customers,	each	of	whom will	contact	a	set	of	banks	to	request a	number	of	loans.	
Eventually,	they	will	either	receive	all	of	the	money they	require or	they	will	end	up	without	
completely	meeting	their	original	objective.	The	application	will	display	information	about	the	
various	banking	transactions	before	it	finishes. That’s	it.	

So	now	for	the	details.	To	begin,	you	will	need	a	handful	of	customers	and	banks.	These	will	be	
supplied	in	a	pair	of	very	simple	text	files – customers.txt and	banks.txt.	While	Erlang	provides	many	
file	primitives	for	processing	disk	files,	the	process is	not	quite	as	simple	as	Clojure’s	slurp()	
function.	So	the	two	files	will	contain	records	that	are	already	pre-formatted.	In	other	words,	they	
are	ready	to	be	read	directly	into	standard Erlang	data	structures.	

An example customers.txt file	would	be:
{jill,450}.
{joe,157}.
{bob,100}.
{sue,125}.

An	example	banks.txt file would	be:
{rbc,800}.
(bmo,700}.
{ing,200}.

In	other	words,	each	file	simply	contains a set	of	erlang	tuples.		You	will	see	that	each	label	is	
associated with	a	number.	For	customers,	this	is	the	total	funds	that	they	are	hoping	to	obtain.	For	
banks,	the	number	represents	their	total	financial	resources	that	can	be	used	for	loans.	
To	read	these	files,	all	you	have	to	use	is	the	consult() function	in	the	file module.	This	will	
load	the	contents	of	either	file	directly	into	an	erlang	structure	(a	list	of	tuples).	 Note	that	NO	error	
checking	is	required.	The	text files are guaranteed	to	exist	and	contain	valid	data.	
In	addition, however,	please	keep	in	mind	that	these	are	just	samples.	The	test	files	will	have	
different	customer/bank	names	and	may	also	contain a	different	numbers	of	customers	or banks	
(but	no	more	than	10	of	either).

So	your	job	now	is	to	take	this	information and	create	an	application	that	models the	banking	
environment. Because	customers and	banks are distinct	entities in	this	world,	each	will	be	modeled	
as	a	separate	task/process.	When	the	application	begins,	it	will	therefore	generate	a	new	process	
for	each	customer and	each bank.	Because	you	do not	know	how	many	customers	or	banks	there	
will	be,	or	even	their	names,	you	cannot	“hard	code” this	phase of	the	application.	
The	customer and	bank tasks	will	then	start	up	and	wait	for	contact	(you	may	want	to	make	each	
new	task	sleep	for	a	100	milliseconds	or	so,	just	to	make	sure	that	all	tasks	have	been	created	and	
are	ready	to	be	used).	
So	the	banking	mechanism	works	as	follows:

1. Each	customer	wants	to	borrow the	amount	listed	in	the	input file.	At	any	one	time,	
however,	they	can	only	request	a	maximum	of	50	dollars.	When	they	make	a	request,	they	
will	therefore	choose	a	random	dollar	amount between	1	and	50	for	their	current	loan.	

2. When	they	make	a	request,	they	will	also	randomly	choose	one	of	the	banks	as	the	target.

3. Before	each	request, a	customer	will	wait/sleep a	random	period	between	10	and	100	
milliseconds.	This	is	just	to	ensure	that	one	customer	doesn’t	take	all	the	money	from	the	
banks	at	once.	

4. So	the	customer will	make	the	request	and	wait	for	a	response	from	the	bank.	It	will	not	
make	another	request	until	it	gets a	reply	about	the	current	request.	

5. The	bank	can	accept	or	reject	the	request.	It	will	reject	the	request	if	the	loan	would	reduce	
its	current	financial	resources below	0.	Otherwise,	it	grants	the	loan	and	notifies	the	
customer.

6. If	the	loan	is	granted,	the	customer	will	deduct	this	amount	from	its	total	loan	requirement
and	then	randomly	choose	a	bank	(possibly	the	same	one)	and	make	another	request	
(again,	between	1	and	50	dollars).

7. If	the	loan	is	rejected,	however,	the	customer will	remove	that	bank	from	its	list of	potential	
lenders,	and	then	submit	a	new	request	to	the	remaining	banks.

8. This	process	continues until	customers	have	either	received	all	of	their	money	or	they	have	
no	available	banks left	to	contact.	
And	that’s	it.	
Of	course,	we	need	a	way	to	demonstrate	that	all	of	this	has	worked	properly.	 To	begin,	it	is	
important	to	understand	that	this	is	a	multi-process	Erlang	program.	The	“master”	process	will	be	
the	initial	process	that,	in	turn, spawns	processes for	each	of	the	customers (the	master	process	is	
like	the	class	containing	“main” in	Java).	So,	in	our	little	example	above,	there	will	be	8 processes	in	
total: the	master,	4	customers	and	3	banks.	
