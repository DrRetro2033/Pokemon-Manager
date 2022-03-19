# Pokémon Manager
View, organize, and manage your Pokémon.
(Pokemon_Manager.png)

What is Pokémon Manager?
-
As the 3ds and Wii U's e-shop draws to a close, all online only services will be lost to time. One of the most consering is Pokémon Bank, as soon your pokémon from the 3DS games, and consequently DS games, and GBA games will be trapped on your console. Thankfully, the 3ds homebrewing and the Pokémon community has already made software to transfer help transfer Pokémon to the switch. The most important software for this process is [PKHeX](https://github.com/kwsch/PKHeX), as it allows users to copy pokémon from one save file to another. [PKHeX](https://github.com/kwsch/PKHeX) is an amazing piece of software, but in my option, the only problem I have with it is the pk database. The pk database is only designed to store copies of Pokémon, but I feel that it could be expanded to be a easier way to store pokémon on your computer. So I created Pokémon Manager with the main goal of being an alternative to Pokémon Bank and Pokémon Home. Pokémon Manager will start out as a Windows exclusive program; but I am planning, after I get the foundation built, to make a linux version too. As I do not have a Mac machine lying around my house, I am not planning to make a Mac version, but because Pokémon Manager is made on the godot engine and open-source, someone could compile it to Mac and test it.

IMPORTANT:
-
Pokémon Manager is not a save editor, it is only able to read PK files. Also, due to my lack of experience of doing projects like Pokémon Manager, I will make a lot of mistakes in terms of optimization and organization. Please feel free to make constructive feedback and help me understand my mistakes. Side note to Nintendo, Game Freak, The Pokémon Company, this program in no way is trying to compete with Pokémon Bank and Pokémon Home, this is just an alternative to people who are willing to homebrew their consoles to store their Pokémon on their computer and in no way condones cheating in any form.

Setup:
-

- Pre-requisites:
  - Have downloaded the latest version of [PKHeX](https://github.com/kwsch/PKHeX), opened a save file, and dumped Pokémon into the database.
  - Pokémon Manager uses [PokéAPI](https://github.com/PokeAPI/pokeapi) to make the code cleaner and save space, but since it's on the internet, you require wifi or ethernet when adding new Pokémon.
- Installing:
  - Download the latest version of Pokémon Manager.
  - Extract the zip file into the same folder as PKHeX.
  - Open Pokémon Manager and enjoy!
  
Features:
- 
 - Displays Pokémon's PokéDex entry.
 - Shows known moves with pp, power, type, and damage class.
 - Stats chart with base stats and ivs.
 - Drag and drop Pokémon into a blank space or switch positions with another Pokémon.
 - Search for specific Pokémon by nickname, typing, and gender.
 - Rename, and add boxes to your liking (Empty boxes are not stored).
 - By my understanding of the Godot Engine, you could theoretically keep Pokémon Manager, [PKHeX](https://github.com/kwsch/PKHeX), and your pokémon on a usb stick and plug it into a brand new computer and it should work. Although [PKHeX](https://github.com/kwsch/PKHeX) will not work unless you install .NET Core onto the computer
 - Level of Pokémon is displayed next to the gender of the pokemon.
 - Ability to make multiple parties.
 - Compatibility with alternate forms (Currently, there are no PokéDex entries for alternate Pokémon in PokéAPI so alternate forms will show the first form's entry nad not the correct form's entry. This will be fixed in a future update)
 - Make a personalized profile.

In progress/Planned:
-
   - Stats chart with ivs, evs, and base stats.
   - pk8, pk4, pk3, pk2, pk1 files will be supported soon.
   - Transfer Pokémon with someone else online.
   - Switch from requiring internet to having PokeAPI's database integrated with Pokémon Manager.
   - Show trainer info (meaning the trainer's name and details) for each Pokémon and search by trainers.
   - Switch PokéDex entries when viewing Pokémon.
   - Switch icons between 3d models, home icons, and sprites.
   - More organization tools.

Credits:
-
Copyright (c) © 2013–2021 Paul Hallett and PokéAPI contributors (https://github.com/PokeAPI/pokeapi#contributing). Pokémon and Pokémon character names are trademarks of Nintendo.
All rights reserved.
