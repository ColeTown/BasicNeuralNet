# BasicNeuralNet
This was a quick project I did back in 2019 in my spare time to experiment with some basic neural network principles. The quality of the code is on par to that of a chimpanzee's and the GUI of the sketch is basically unusable unless you wrote the code, however, I will try and explain how to use this program. 

I have no intention of improving the interface for this project. I would just as soon scrap all of it and start over if I was to do that.

# How To Create A Track
When initially running the program two buttons will show up: "Create Track" and "Load Track".
To create a track click the former button.

To build the walls of the track you use left click to add a vertex.
In order to delete a vertex you use right click.
In order to end a wall you should press your mouses middle button. After clicking the middle button you can start a new wall by left clicking again. 

Once the walls are finished how you would like them you need to add checkpoints to your track that the genetic algorithm will use to determine the fitness of the neural networks. To start placing checkpoints you click the button in the top left of the window that says 'Make Checkpoints'. You will add checkpoints in a similar way as how you made your wall but each checkpoint will only use two vertices and then will move on to the next to vertices. Be sure to remember the first Checkpoint you placed and the order that you placed them as the 'cars' are looking for the checkpoints in the order that they were made. What I do is place the first two checkpoints very close together so that I know which checkpoints are the first. 

Once you are satisfied with the track you should click the 'Save track' button in the top left. 

# How To Use An Old Track
The way to use an old track is really simple. Whenever you save a track during track creation a file is saved in the project folder called 'track.txt' with which the program will build the track from. This track will be overwritten if you are to make a new track, so if you want to save a track permanently, make sure and save the file outside of the project folder locally. 

To load a track when the program is first ran, simply click the 'Load track' button on the starting page. 

# How To Start The Network Training
Once you have saved or loaded a track the next two left clicks will start the training. The first click will choose a starting position of the 'cars' and the next click will create a direction vector for which direction the 'cars' will be facing on creation. These two clicks will determine the location and heading on the screen. 

Once the cars are training they will continue to train unless you stop the program. Each generation will continue until all of the cars have crashed, the time limit for each generation is reached, or you can left click and start a new generation manually. 


If you want to save the neural networks in a file you can right click and a text file will be saved with all the neural networks relevant data. To load a saved set of neural networks you should middle click BEFORE setting the cars location and direction. 
