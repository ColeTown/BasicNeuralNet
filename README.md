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
