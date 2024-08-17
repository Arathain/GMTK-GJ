extends Node

var level := 1;
var nextLevel := 5;
var components : Array[int] = [0, 0, 0]

func addComponent(type : GlobalStorage.CellType):
	components[type] += 1;
	if(components[0] + components[1] + components[2] >= nextLevel):
		levelUp(getHighest());
		components = [0, 0, 0];
	
func levelUp(type : GlobalStorage.CellType):
	level += 1;
	nextLevel += 5;
	SignalBus.levelUp.emit(type);

func getHighest():
	if(components[0] > components[2]):
		if(components[1] > components[0]):
			return 1;
		else:
			return 0;
	else:
		if(components[1] > components[2]):
			return 1;
		else:
			return 2;
