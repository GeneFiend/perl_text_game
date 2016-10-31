#!/usr/bin/perl
#By: Patrick Brennan
$cargo=10;
$health=100;
$oxygen=100;
$thirst=100;
$hunger=100;
$miles_to_target=1500;
$miles_traveled=0;
$range_low=20;
$range_high=35;
$blown_tires=0;
%inventory=();

print "Welcome to Journey the Unknown!
Please enter your first name and press <enter>:\n";
$user_name=<STDIN>;
chomp $user_name;
#going to be a oregon trail game but space rover to reach
#launch site. can choose between mechanic/navigator/botanist

print "$user_name, you have just crash landed on an unknown planet.
Your crew is dead. Right before crashing, your crew picked up a radio
signal 1500 miles North of the crash site. This unknown signal is your
only chance of survival. Luckily, the rover seems to have survived the
crash. You must load up the rover with supplies and make the journey
to the location of the unknown signal. It may be your only way off
this planet.....\n";

&break;

print "Before you begin your journey $user_name, what was your profession again?
Mechanic: More skill at reparing the rover
Botanist: Loses oxygen slower
Navigator: Travels more miles per day
[type 'b' and press <enter> if you would like to be the botanist
type 'm' and press <enter> if you would like to be the mechanic
type 'n' and press <enter> if you would like to be the navigator]\n";

$prof=<STDIN>;
chomp $prof;

if ($prof eq 'b') {$prof = 'botanist';}
elsif ($prof eq 'm') {$prof = 'mechanic';}
elsif ($prof eq 'n') {$prof = 'navigator';}
else {print "You did not select a profession. Please try again.\n";}
print "Congratulations! You are a $prof!\n";

&break;

print "Now it is time to pack up the rover and embark on the journey. Before leaving,
you scour the crash site for possible supplies. The rover can hold 10 items.
The items you decide to bring will determine whether you live or die. Looking
around the crash site, you find: oxygen canisters, spare tires, medical packs, 
bottles of water, and crates of food.\n";

%inventory = (
	'bottles of water' => 0,
	'crates of food' => 0,
	'sets of spare tires'  => 0,
	'oxygen canisters' => 0,
	'medical packs' =>0,
);


foreach $name (keys %inventory) {
	print "Space remaining: $cargo\n";
	print "How many $name do you want to bring?\n";
	$inv_count=<STDIN>;
	chomp $inv_count;
	$inventory{$name}=$inventory{$name} + $inv_count;
	$cargo= $cargo - $inv_count;
}
#$blaster_rounds=100*$inventory{'cases of blaster rounds'};
&main;

sub main {
	if ($miles_to_target<=0) {&win;}
	if ($hunger<=0||$health<=0||$oxygen<=0) {&lose;}
	print "________MAIN MENU_________\n$user_name\'s Health= $health\tOxygen=$oxygen%\tBlown Tires=$blown_tires\tHunger=$hunger\tThirst=$thirst\nMiles to go=$miles_to_target\tMiles Traveled=$miles_traveled\n\n";
	print "What would you like to do?
	**Check Inventory (i)
	**Travel(t)
	**Rest(r)
	**Use item (u)\n";
	
	$choice=<STDIN>;
	chomp $choice;
	if ($choice eq 'i') {&inventory;}
	elsif ($choice eq 't'){&travel;}
	elsif ($choice eq 'r'){&rest;}
	elsif ($choice eq 'u'){&use_item;}
	else {print "Incorrect Input. Try again.\n"; &main;}
}
	
sub inventory {
	print "\n _____INVENTORY______\n";
	foreach $item (keys %inventory) {
		print "$item\t$inventory{$item}\n";		
	}
	&break;&main;
}

sub travel {
	$hunger=$hunger-2;
	if ($prof eq 'botanist') {
		$oxygen=$oxygen-2;
	}
	else {$oxygen=$oxygen-3;}
	$thirst=$thirst-3;
	$| = 1;
	print "Your day of travel begins...\n";
	for (1..6) {
        print '.';
        sleep 1;
    }
    print "\n";
	$rand=int(rand(2));
	if ($rand=0 || $rand=1) {&event;}
	$speed=($range_low + int(rand($range_high-$range_low))) - ($blown_tires*5);
	if ($prof eq 'navigator') {$speed=$speed + 4;}
	$miles_to_target=$miles_to_target-$speed;
	$miles_traveled=$miles_traveled+$speed;
	print "You traveled $speed miles today.\n";
	&break;&main;
}

sub event {
	$rand2=int(rand(5));
	if ($rand2==0 || $rand2==4) {&event_beetle;}
	if ($rand2==1) {&event_slug;}	
	if ($rand2==2) {&event_ooze;}
	if ($rand2==3) {&event_airsac;}
}
		
sub event_beetle {		
	$rand3=int(rand(4));
	print "Oh no! A huge radioactive beetle blocks your way!
	What would you like to do?
	**Attempt to run it over (r)
	**Attack with your blaster (b)
	**Turn back (t)\n";
	$action=<STDIN>;
	chomp $action;
	if ($action eq 't') {print "You turn back like a coward. You traveled 0 miles today.\n\n";&break; &main;}
	elsif ($action eq 'r') {
		print "You slam on the gas petal and hear the beetle satifyingly crunch under your tires!\n";
		if (($rand3==2 || $rand3==3) && $blown_tires < 4) {
			print "But as you ran over the beetle, you hear a 'POW'. One of your tires has blown!\nYou will travel 5 fewer miles per day until it is repaired.\n\n";
			$blown_tires++;
		}
	}
	elsif ($action eq 'b') {
		$beetle_health=15;
		while ($beetle_health >0) {
			$rand4=int(rand(3))+1;
			$rand5=int(rand(3))+1;
			print "____BATTLE BEGINS____\nBeetle's Health=$beetle_health\t$user_name\'s Health=$health\n";
			sleep 2;
			print "$user_name fires the blaster for $rand4 damage......\n";
			sleep 1;
			print "\t\t......Beetle sprays acid for $rand5 damage\n";
			sleep 1;
			$health=$health-$rand5;
			$beetle_health=$beetle_health-$rand4
		}
	

	}
	else {print "Invalid Input. Try again.\n"; &event_beetle;}
	
}
sub event_ooze {
	print "You come across a bubbling pool of ooze.....
	Drink it?
	**Yes (y)
	**No (n)\n";
	$action=<STDIN>;
	chomp $action;
		
	if ($action eq 'y') {
		print "\nThe purple ooze slides down your throat.\nYour thirst feels quenched, but you immediately get sharp pains in your intestines...\n+10 Thirst\n-10 Health\n";
		$thirst=$thirst+10;
		$health=$health-10;
	}
	elsif ($action eq 'n') {print "\nYou decide not to risk it and keep driving\n";}
	else {print "Invalid Input. Try again.\n"; &event_ooze;}
}

sub event_slug {
	print "\nYou come across a tumorous slug sliding across the ground.......\n\tEat it?\n\t**Yes (y)\n\t**No (n)\n";
	$action=<STDIN>;
	chomp $action;
	if ($action eq 'y') {
		print "\nThe disgusting slug slides down your throat.\nYour hunger feels satisfied, but the slug is unbearably salty and you suddenly feel parched\n+10 Hunger\n-10 Thirst\n";
		$hunger=$hunger+10;
		$thirst=$thirst-10;
	}
	elsif ($action eq 'n') {print "\nYou decide not to risk it and keep driving\n";}
	else {print "Invalid Input. Try again.\n"; &event_slug;}
	
}

sub event_airsac {
	print "\nYou come across a bulbous membrane that appears to filled with gas.......\n\tBreath it?\n\t**Yes (y)\n\t**No (n)\n";
	$action=<STDIN>;
	chomp $action;
	if ($action eq 'y') {
		print "\nYou slice open the membrane and inhale the gas.\nThe gas highly oxygenates your blood causing you to feel lightheaded and vomit...\n+10 Oxygen\n-10 Hunger\n";
		$oxygen=$oxygen+10;
		$hunger=$hunger-10;
	}
	elsif ($action eq 'n') {print "\nYou decide not to risk it and keep driving\n";}
	else {print "Invalid Input. Try again.\n"; &event_airsac;}
}

sub rest {
	
	if ($health<=95) {print "\nAhhhh! A long days rest does good for the health.
	+5 Health
	-5 Oxygen
	-1 Hunger
	-1 Thirst\n";$health=$health+5;$oxygen=$oxygen-5;$hunger=$hunger-1;$thirst=$thirst-1;&break; &main;}
	else {print "Health cannot go above 100. Choose another action.\n";&break; &main;}
}

sub use_item {
	print "\n _____INVENTORY______\n";
	foreach $item (keys %inventory) {
		print "$item\t$inventory{$item}\n";
	}
		print "\nWhich Item would you like to use?
	**Medical Pack (increases health by 25) (m)
	**Bottle of water (increases thirst by 35) (w)
	**Crate of food (increases hunger by 35) (f)
	**Oxygen canisters (increases oxygen by 35) (o)
	**Set of tires (repairs rover back to 100%. May take several days.) (t)
	**Back to main menu (b)\n";
			$choice2=<STDIN>;
			chomp $choice2;
			if ($choice2 eq 'm') {
				if ($inventory{'medical packs'} > 0 && $health <=75) {$health=$health+25;$inventory{'medical packs'}=$inventory{'medical packs'}-1;}
				elsif ($inventory{'medical.packs'} > 0 && $health > 75) {$health=100; $inventory{'medical packs'}=$inventory{'medical packs'}-1;}}
			elsif ($choice2 eq 'w') {
				if ($inventory{'bottles of water'} > 0 && $thirst <=65) {$thirst=$thirst+35;$inventory{'bottles of water'}=$inventory{'bottles of water'}-1;}
				elsif ($inventory{'bottles of water'} > 0 && $thirst > 65) {$thirst=100;$inventory{'bottles of water'}=$inventory{'bottles of water'}-1;}}
			elsif ($choice2 eq 'f') {
				if ($inventory{'crates of food'} > 0 && $hunger <=65) {$hunger=$hunger+35;$inventory{'crates of food'}=$inventory{'crates of food'}-1;}
				elsif ($inventory{'crates of food'} > 0 && $hunger > 65) {$hunger=100;$inventory{'crates of food'}=$inventory{'crates of food'}-1;}}
			elsif ($choice2 eq 'o') {
				if ($inventory{'oxygen canisters'} > 0 && $oxygen <=65) {$oxygen=$oxygen+35;$inventory{'oxygen canisters'}=$inventory{'oxygen canisters'}-1}
				elsif ($inventory{'oxygen canisters'} > 0 && $oxygen > 65) {$oxygen=100;$inventory{'oxygen canisters'}=$inventory{'oxygen canisters'}-1}}
			elsif ($choice2 eq 't') {
				if ($prof eq 'mechanic' && $inventory{'sets of spare tires'} > 0 && $blown_tires >=1) {
					print "It tooks you two days to repair the tires.\n-4 hunger\n-6 oxygen\n-6thirst\n";
					$hunger=$hunger-4;
					$oxygen=$oxygen-6;
					$thirst=$thirst-6;
					$blown_tires=0;
					$inventory{'sets of spare tires'}=$inventory{'sets of spare tires'} - 1;
					&break;
				}
				elsif ($inventory{'sets of spare tires'} > 0 && $blown_tires >=1) {
					$blown_tires=0;
					$inventory{'sets of spare tires'}=$inventory{'sets of spare tires'}-1;
					print "It tooks you five days to repair the tires.\n-10 Hunger\n-15 Oxygen\n-15 Thirst\n";
					$hunger=$hunger-10;
					$oxygen=$oxygen-15;
					$thirst=$thirst-15;
					&break;
				}
			}
			elsif ($choice2 eq 'b') {&main;}
			else {print "Incorrect command.\n"; &use_item;}
			
&main;
}

sub win {
	die "
	$user_name stumbles out of the rover exhausted and near death.
	You see a blinking terminal in the distance and start to crawl toward it.
	The terminal appears to have a single blinking button. Seeing no other
	options, you decided to push it......
	
	The ground begins to rumble and part ways. Sand seeps through the widening
	crack in the ground and you scramble out of the way to avoid falling in.
	The crack reveals a staircase that descends deep down into the planet.
	Suffering from exhaustion, you are unable to climb down the stairs. Instead
	you simply lay at the top and await your fate.....
	
	Barely conscious, you feel several small, gentle hands pick you up and begin
	carrying you down the stairs. Mustering the effort to open your eyes you peer
	out and see a small creature looking back at you. You look into its eyes and
	you know the creature means you no harm. As your worries disappear, you drift
	off into a peaceful sleep as you descend into your new home. \n";
	
}

sub lose {
	die "$user_name has died an awful death. You were $miles_to_target miles away. Please play again....\n";
	
}

sub break {
	print"Press <enter> to continue\n";
	$break=<STDIN>;
	chomp $break;
}
