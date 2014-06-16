module main;

void main(string[] args){
	import pot, std.stdio, std.string;
	
	auto engine = new Engine;
	engine.initializeRandom;
	bool quit = false;
	while(!engine.finished && !quit){
		engine.printBoard;
		auto cmd = stdin.readln.strip in cmdTable;
		if(!cmd)
		{
			writeln("Invalid command");
			continue;
		}
		
		switch(*cmd)
		{
		case Command.ShiftLeft:
			engine.shift!(Direction.Left);
			break;
		case Command.ShiftRight:
			engine.shift!(Direction.Right);
			break;
		case Command.ShiftUp:
			engine.shift!(Direction.Up);
			break;
		case Command.ShiftDown:
			engine.shift!(Direction.Down);
			break;
		case Command.Quit:
			quit = true;
			break;
		case Command.Save:
			writeln("Not implemented yet.");
			break;
		default:
			throw new Exception("Should not reach here..");
		}
		
	}
}

enum Command
{
	ShiftLeft,
	ShiftRight,
	ShiftUp,
	ShiftDown,
	Quit,
	Save
}

Command[string] cmdTable; /* = [
	"up" : Command.ShiftUp,
	"down": Command.ShiftDown,
	"left": Command.ShiftLeft,
	"right": Command.ShiftRight,
	"quit": Command.Quit,
	"save": Command.Save
]; */

static this()
{
	cmdTable["up"] = Command.ShiftUp;
	cmdTable["down"] = Command.ShiftDown;
	cmdTable["left"] = Command.ShiftLeft;
	cmdTable["right"] = Command.ShiftRight;
	cmdTable["quit"] = Command.Quit;
	cmdTable["save"] = Command.Save;
}