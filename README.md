# Slipbox

To setup this project you need to have a paid developer account, because the project is using Core Data with iCloud sync. Go to project settings under target / signing & capabilities and add team. 
You also will need to create a iCloud container under the iCloud capabilities.

##Zettelkasten
The app is a note taking system invented by a German sociologist Lukas Luhmann. You can find more information on the Zettelkasten here:
https://zettelkasten.de


<img width="1019" alt="Screenshot 2020-12-21 at 15 57 45" src="https://user-images.githubusercontent.com/53653631/102917040-2d899180-448d-11eb-8911-9d4f9570f3fe.png">

When you open the application, you get one window with a toolbar and 4 columns. You can create more windows under the menu Window / new Window.
The app uses a AppDelegate. So we don't get support for the .toolbar modifiers, which work with windowgroup. The toolbar is coded with a NSToolbar (in the project under SlipboxApp / main window). There are 3 toggles in the toolbar to show/hide the keyword column, folder column and notes column.


<img width="924" alt="Screenshot 2020-12-22 at 19 40 17" src="https://user-images.githubusercontent.com/53653631/102918377-76dae080-448f-11eb-9dd4-5edbd94bfa67.png">

You can create new keywords, folder and notes. All elements support drag and drop, so you can drag a keyword to a note to add it. You can drag a note to another note to create a link between these two notes.


Linked notes appear in the lower part of the note editor area. You can right click on a link and have the option to open the link in a new note.


<img width="1679" alt="Screenshot 2020-12-22 at 19 45 02" src="https://user-images.githubusercontent.com/53653631/102917631-3cbd0f00-448e-11eb-9ca9-52ce6eab7ac3.png">
