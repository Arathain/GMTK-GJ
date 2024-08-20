extends Node

signal cell_death(cell);

signal cell_component_pickup(cell : CellComponent);

signal levelUp(type : GlobalStorage.CellType, array : Array[int], nextLevel : int);
signal cellUpgrade(type : PlayerStorage.UpgradeType);
signal cellDowngrade(type : PlayerStorage.UpgradeType);
