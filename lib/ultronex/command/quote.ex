require Logger

defmodule Ultronex.Command.Quote do
  @moduledoc """
  Documentation for Ultronex.Command.Quote
  """
  alias Ultronex.Realtime.Msg, as: Msg
  alias Ultronex.Utility, as: Utility

  def random(slack_message, slack_state, _msg_list) do
    Logger.info("Ultronex.Command.Quote.random")

    quote =
      "<@#{slack_message.user}>!, `I, UltronEx chose this for you` #{
        get_quote_to_send() |> format()
      }"

    Logger.info(quote)
    Msg.send(quote, slack_message.channel, slack_state)
  end

  def get_quote_to_send do
    quotes() |> List.pop_at(randon_quote_index()) |> elem(0)
  end

  def format(quote) do
    quote |> Msg.format_block()
  end

  def randon_quote_index do
    quotes() |> Kernel.length() |> Utility.random()
  end

  def quotes do
    [
      ~s("Strange women lying in ponds distributing swords is no basis for a system of government. Supreme executive power derives from a mandate from the masses, not from some farcical aquatic ceremony." — Dennis the Peasant, Monty Python and the Holy Grail),
      ~s("Three rings for the Elven kings under the sky, seven for the Dwarf lords in their halls of stone, nine for the mortal men doomed to die, one for the Dark Lord on his dark throne, in the land of Mordor where the shadows lie. One ring to rule them all, one ring to find them, one ring the bring them all, and in the darkness bind them. In the land of Mordor where the shadows lie." -LOTR),
      ~s("I'm sorry, Dave. I'm afraid I can't do that." - HAL, 2001: A Space Odyssey),
      ~s("Spock. This child is about to wipe out every living thing on Earth. Now, what do you suggest we do….spank it?" — Dr. McCoy, Star Trek: The Motion Picture),
      ~s("With great power there must also come — great responsibility."  - Amazing Fantasy #15 \(August 1962\)),
      ~s("If you can't take a little bloody nose, maybe you oughtta go back home and crawl under your bed. It's not safe out here. It's wondrous, with treasures to satiate desires both subtle and gross; but it's not for the timid." — Q, Star Trek: The Next Generation  “Q Who?"),
      ~s("Five card stud, nothing wild. And the sky's the limit" — Captain Jean Luc Picard, uttering the last line of the series, Star Trek: The Next Generation   “All Good Things…"),
      ~s("If you think that by threatening me you can get me to do what you want… Well, that's where you're right. But - and I am only saying that because I care - there's a lot of decaffeinated brands on the market that are just as tasty as the real thing." - Chris Knight, Real Genius),
      ~s("We're all very different people. We're not Watusi. We're not Spartans. We're Americans, with a capital ‘A', huh? You know what that means? Do ya? That means that our forefathers were kicked out of every decent country in the world. We are the wretched refuse. We're the underdog." - John Winger, Stripes),
      ~s("If I'm not back in five minutes, just wait longer." - Ace Ventura, Ace ventura, Pet Detective),
      ~s("I'm going to give you a little advice. There's a force in the universe that makes things happen. And all you have to do is get in touch with it, stop thinking, let things happen, and be the ball." - Ty Webb, Caddyshack),
      ~s("WE APOLOGIZE FOR THE INCONVENIENCE - God \(Douglas Adams\), So Long, and Thanks for All the Fish),
      ~s("Some days, you just can't get rid of a bomb!" - Adam West, Batman & Robin),
      ~s("Bill, strange things are afoot at the Circle K." - Ted, Bill & Ted's Excellent Adventure),
      ~s("Invention, my dear friends, is 93% perspiration, 6% electricity, 4% evaporation, and 2% butterscotch ripple." - Willy Wonka, Willy Wonka & the Chocolate Factory),
      ~s("Didja ever look at a dollar bill, man? There's some spooky shit goin' on there. And it's green too." - Slater, Dazed and Confused),
      ~s("Alright, alright alright." - Wooderson, Dazed and Confused),
      ~s("Heya, Tom', it's Bob from the office down the hall. Good to see you, buddy; how've you been? Things have been alright for me except that I'm a zombie now. I really wish you'd let us in." Jonothan Coulton, Re: Your Brains),
      ~s("Never argue with the data." - Sheen, Jimmy Neutron),
      ~s("Oooh right, it's actually quite a funny story once you get past all the tragic elements and the over-riding sense of doom." - Duckman \(Jason Alexander\)),
      ~s("Fantastic!" - The Doctor \(Christopher Eccleston\), Doctor Who),
      ~s("I must not fear. / Fear is the mind-killer. / Fear is the little-death that brings total obliteration. / I will face my fear. / I will permit it to pass over me and through me. / And when it has gone past I will turn the inner eye to see its path. / Where the fear has gone there will be nothing. / Only I will remain." - Bene Gesserit Litany Against Fear, Dune),
      ~s("This is the way society functions. Aren't you a part of society?" - Kramer, Seinfeld),
      ~s("Okay. You people sit tight, hold the fort and keep the home fires burning. And if we're not back by dawn… call the president." - Jack Burton, Big Trouble in Little China),
      ~s("No matter where you go, there you are. " - Buckaroo Banzai, Buckaroo Banzai Across the Eighth Dimension),
      ~s("Do you know of the Klingon proverb that tells us revenge is a dish that is best served cold? It is very cold in space." -Khan, ST:TWOK),
      ~s("Ray, if someone asks you if you're a god, you say YES!" - Winston, Ghostbusters),
      ~s("Greetings, programs!" -Flynn, TRON),
      ~s("I guess you picked the wrong god-damned rec room to break into, didn't you?!" -Burt, Tremors),
      ~s("I find your lack of faith disturbing." -Darth Vader, Star Wars),
      ~s("Hokey religions and ancient weapons are no substitute for a good blaster at your side, kid." -Han Solo, Star Wars),
      ~s("Try not. Do, or do not. There is no try." - Yoda, The Empire Strikes Back),
      ~s("It's a moral imperative." - Chris Knight, Real Genuis),
      ~s("Talk with your mouth full / bite the hand that feeds you / bite off more than you can chew / dare to be stupid" - Weird AL   “dare to be stupid."),
      ~s("Well, let's say this Twinkie represents the normal amount of psychokinetic energy in the New York area. Based on this morning's reading, it would be a Twinkie thirty-five feet long, weighing approximately six hundred pounds." - Egon, Ghostbusters),
      ~s("This episode was BADLY written!" -Gwen, Galaxy Quest),
      ~s("Worst. Episode. Ever." - Comic Book Guy, The Simpsons),
      ~s("Goonies never say die." -Mike, The Goonies),
      ~s("Nothing shocks me-I'm a scientist." - Indiana Jones, Indiana Jones and the Temple of Doom),
      ~s("Bright light! Bright light!" - Gremlins),
      ~s("The Road goes ever on and on/Down from the door where it began/Now far ahead the Road has gone/And I must follow, if I can/Pursuing it with eager feet/Until it joins some larger way/Where many paths and errands meet/And whither then? I cannot say." - J.R.R. Tolkien, Lord of the Rings),
      ~s("Human sacrifice, dogs and cats living together… mass hysteria!" - Dr. Peter Venkman, Ghostbusters),
      ~s("If we knew what it was we were doing, it would not be called research, would it?" - Albert Einstein),
      ~s("Wait a minute, Doc. Ah… Are you telling me you built a time machine… out of a DeLorean?" - Marty McFly, Back to the Future),
      ~s("Don't call me a mindless philosopher, you overweight blob of grease!" - C3PO, Star Wars),
      ~s("I'd just as soon kiss a wookiee!" - Princess Leia, The Empire Strikes Back),
      ~s("But one thing's sure: Inspector Clay is dead, murdered, and somebody's responsible." - Detective, Plan 9 from Outer Space),
      ~s("I know kung fu." - Neo, The Matrix),
      ~s("This is your receipt for your husband… and this is my receipt for your receipt." - Officer, Brazil),
      ~s("Your soul-suckin' days are over, amigo!" - Elvis, Bubba Ho-Tep),
      ~s("I don't believe there's a power in the ‘verse that can stop Kaylee from being cheerful. Sometimes you just wanna duct-tape her mouth and dump her in the hold for a month." - Malcolm Reynolds, Firefly \(episode:  “Serenity" \(pilot\)\)),
      ~s("Would you say I have a plethora of pinatas?" - El Guapo, Three Amigos!),
      ~s("Never go in against a Sicilian when death is on the line!" Vizzini, The Princess Bride),
      ~s("There is no Earthly way of knowing… which direction we are going. There is no knowing where we're rowing, or which way the river's flowing. Is it raining? Is it snowing? Is a hurricane a'blowing? Not a speck of light is showing so the danger much be growing. Are the fires of hell a'glowing? Is the grisley reaper mowing? YES! The danger must be growing for the rowers keep on rowing AND THEY'RE CERTAINLY NOT SHOWING ANY SIGNS THAT THEY ARE SLOWING!!" - Willy Wonka, Willy Wonka & the Chocolate Factory),
      ~s("Time... to die." - Roy Batty, Blade Runner),
      ~s("Now I am become Death, the destroyer of worlds" J. Robert Oppenheimer),
      ~s("Check, please." - Lone Starr & Barf, Spaceballs),
      ~s("So say we all." - Battlestar Galactica),
      ~s("After very careful consideration, sir, I've come to the conclusion that your new defense system sucks." - General Beringer, WarGames.),
      ~s("I am a leaf on the wind, watch how I soar." - Wash, Serenity),
      ~s("No matter what you hear in there, no matter how cruelly I beg you, no matter how terribly I may scream, do not open this door or you will undo everything I have worked for." - Young Frankenstein),
      ~s("Ahh, a bear in his natural habitat: a Studebaker." Fozzie, The Muppet Movie),
      ~s("He's dead, Jim." McCoy, ST:TOS),
      ~s("Who's gonna turn down a Junior Mint? It's chocolate, it's peppermint - it's delicious!" - Kramer, Seinfeld),
      ~s("Bring out your dead." Monty Python and the Holy Grail),
      ~s("My name is Inigo Montoya. You killed my father. Prepare to die!" -Inigo, The Princess Bride),
      ~s("Why a duck? Why-a no chicken?" - Chico Marx, Cocoanuts),
      ~s("Redrum." Danny, The Shining),
      ~s("Who knows what evil lurks in the hearts of men? The Shadow knows." - announcer, The Shadow radio drama),
      ~s("We're going to need a bigger boat." - Chief Brody, Jaws),
      ~s("Oooh, ahhh, that's how it always starts. Then later there's running and screaming." - Ian Malcolm, The Lost World: Jurassic Park),
      ~s("Greetings, my friend. We are all interested in the future, for that is where you and I are going to spend the rest of our lives. And remember my friend, future events such as these will affect you in the future." Criswell, Plan 9 from Outer Space),
      ~s("Gentlemen, you can't fight in here! This is the War Room!" - President Merkin Muffley, Dr. Strangelove),
      ~s("These aren't the droids you're looking for." - Obi-Wan, Star Wars),
      ~s("Take your stinking paws off me, you damn dirty ape!" - Taylor, Planet of the Apes),
      ~s("You maniacs! You blew it up! Oh, damn you! Damn you all to hell!" - Taylor, Planet of the Apes),
      ~s("Klaatu barada nikto." The Day the Earth Stood Still),
      ~s("Monsters from the Id." - Doc Ostrow, Forbidden Planet),
      ~s("ET phone home." - ET),
      ~s("What… is the air-speed velocity of an unladen swallow?" - Bridgekeeper, Monty Python and the Holy Grail),
      ~s("We thought you was a toad!" - Delmar, O Brother Where Art Thou?),
      ~s("Face it tiger, you just hit the jackpot!"-Mary Jane, Spider-Man.),
      ~s("You don't have to be a gun."-Hogarth, The Iron Giant.),
      ~s("Danger Will Robinson! Danger!" - Robbie the Robot, Lost in Space),
      ~s("Yeah, well. The Dude abides." - The Dude, The Big Lebowski),
      ~s("All things serve the beam." various instances, The Dark Tower series),
      ~s("You can't fool me! There ain't no Sanity Clause!" - Chico Marx, A Night at the Opera),
      ~s("Like the fella says, in Italy for 30 years under the Borgias they had warfare, terror, murder, and bloodshed, but they produced Michelangelo, Leonardo da Vinci, and the Renaissance. In Switzerland they had brotherly love - they had 500 years of democracy and peace, and what did that produce? The cuckoo clock." - Harry Lime, The Third Man),
      ~s("And I said, I don't care if they lay me off either, because I told, I told Bill that if they move my desk one more time, then, then I'm, I'm quitting, I'm going to quit. And, and I told Don too, because they've moved my desk four times already this year, and I used to be over by the window, and I could see the squirrels, and they were married, but then, they switched from the Swingline to the Boston stapler, but I kept my Swingline stapler because it didn't bind up as much, and I kept the staples for the Swingline stapler and it's not okay because if they take my stapler then I'll set the building on fire…" - Milton Waddams, Office Space),
      ~s("Michael, I did nothing. I did absolutely nothing, and it was everything that I thought it could be." - Peter Gibbons, Office Space),
      ~s("Now I have a machine gun. Ho ho ho." - John McClane \(in writing\), Die Hard),
      ~s("Gimme some sugar, baby." - Ash, Army of Darkness),
      ~s("Well hello Mister Fancypants. Well, I've got news for you pal, you ain't leadin' but two things, right now: Jack and sh*t… and Jack left town." - Ash, Army of Darkness),
      ~s("Kneel before Zod." - Zod, Superman II),
      ~s("Shall we play a game?" - Joshua, WarGames),
      ~s("Daddy would have gotten us Uzis." - Samantha, Night of the Comet),
      ~s("It's 106 miles to Chicago, we've got a full tank of gas, half a pack of cigarettes, it's dark and we're wearing sunglasses."   “Hit it!" - Elwood, The Blues Brothers),
      ~s("Make it so" /  “Engage" - Captain Picard, Star Trek: The Next Generation),
      ~s("Ya Ta!" - Hiro Nakamura, Heroes),
      ~s("End Of Line" - The MCP, TRON),
      ~s(Roses are #FF0000, Violets are #0000FF. All my base Are belong to you someone on SlashDot.),
      ~s(There is no place like 127.0.0.1.),
      ~s(Girls are like Internet Domain names; the ones I like are already taken.),
      ~s(Programming today is a race between software engineers striving to build bigger and better idiot-proof programs, and the Universe trying to produce bigger and better idiots. So far, the Universe is winning.),
      ~s(Computers are incredibly fast, accurate, and stupid; humans are incredibly slow, inaccurate and brilliant; together they are powerful beyond imagination. Albert Einstein),
      ~s(There are 10 types of people in the world: Those who understand binary and those who don't.),
      ~s(If at first you don't succeed, call it version 1.0),
      ~s(1f u c4n r34d th1s u r34lly n33d t0 g37 l41d),
      ~s(I'm not anti-social; I'm just not user friendly.),
      ~s(I would love to change the world, but they won't give me the source code),
      ~s(My Software never has bugs. It just develops random features.),
      ~s(The speed of sound is defined by the distance from door to computer divided by the time interval needed to close the media player and pull up your pants when your mom shouts “OH MY GOD WHAT ARE YOU DOING!!!),
      ~s(The glass is neither half-full nor half-empty: it's twice as big as it needs to be.),
      ~s(Passwords are like underwear. You shouldn't leave them out where people can see them. You should change them regularly. And you shouldn't loan them out to strangers),
      ~s(Enter any 11-digit prime number to continue.),
      ~s(A Life? Cool! Where can I download one of those?),
      ~s(I spent a minute looking at my own code by accident. I was thinking "What the hell is this guy doing?"),
      ~s(Concept: On the keyboard of life, always keep one finger on the escape button.),
      ~s(Alert! User Error. Please replace user and press any key to continue.),
      ~s(If builders built buildings the way programmers wrote programs, then the first woodpecker that came along would destroy civilization. Weinberg's Second Law),
      ~s(A computer lets you make more mistakes faster than any invention in human history - with the possible exceptions of handguns and tequila.),
      ~s(People say that if you play Microsoft CDs backwards, you hear satanic things, but thats nothing, because if you play them forwards, they install Windows.),
      ~s(In a world without fences and walls, who needs Gates and Windows?),
      ~s(Failure is not an option — it comes bundled with Windows),
      ~s(JUST SHUT UP AND REBOOT!!),
      ~s(Microsoft: You've got questions. We've got dancing paperclips.),
      ~s(Software is like sex: Its better when its free.),
      ~s(Better to be a geek than an idiot.),
      ~s(Who needs friends? My PC is user friendly.),
      ~s(A penny saved is 1.39 cents earned, if you consider income tax.)
    ]
  end
end
