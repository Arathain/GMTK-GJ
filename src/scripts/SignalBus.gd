extends Node

signal cell_death(cell);

signal cell_component_pickup(cell : CellComponent);

signal levelUp(type : GlobalStorage.CellType);
signal cellUpgrade(type : PlayerStorage.UpgradeType);
