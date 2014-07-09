module pot;

enum Direction
{
	Up,
	Down,
	Left,
	Right
}

pure bool isNegative(Direction direction)
{
	return direction == Direction.Up || direction == Direction.Left;
}

pure bool isVertical(Direction direction)
{
	return direction == Direction.Up || direction == Direction.Down;
}

class Engine
{
	enum BOARD_SIZE = 4; // dimension of board
	
	private Board board = Board(BOARD_SIZE);
	
	void initializeRandom()
	{
		insertBox();
		insertBox();
	}
	
	void shift(Direction direction)()
	{
		import std.algorithm, std.array, std.range;
		
		if(!checkShift!direction) return;
		
		foreach(vector; board.byVector(direction.isVertical))
		{
			
			static if(!direction.isNegative)
			{
				auto data = vector.retro.filter!(a => a > 0);
			}
			else
			{
				auto data = vector.filter!(a => a > 0);
			}
			
			bool alreadyCollapsed = false;
			auto collapsed = (cast(int[])[]).reduce!((sofar, x){
				if(sofar.length>0 && sofar[$-1] == x && !alreadyCollapsed)
				{
					sofar[$-1] *= 2;
					alreadyCollapsed = true;
				}
				else
				{
					sofar ~= x;
					alreadyCollapsed = false;
				}
				return sofar;
			})(data);
			
			vector.fill(0);
			
			static if(!direction.isNegative)
			{
				collapsed.copy(vector.retro);
			}
			else
			{
				collapsed.copy(vector);
			}
			
		}
		insertBox();
	}
	
	// checks to see if shifting towards a certain direction is a valid move
	// a shift is only valid if there is an existing box that will move
	bool checkShift(Direction direction)()
	{
		import std.range;
		
		foreach(vector; board.byVector(direction.isVertical))
		{
			bool foundEmpty;
			int lastBox;
			
			static if(direction.isNegative)
			{
				alias vector vectorNormalized;
			}
			else
			{
				auto vectorNormalized = vector.retro;
			}
			
			foreach(box; vectorNormalized)
			{
				if(box > 0)
				{
					if(foundEmpty) return true;
					if(lastBox == box) return true;
					lastBox = box;
				}
				else if(box == 0)
				{
					foundEmpty = true;
				}
			}
		}
		return false;
	}
	
	void insertBox()
	{
		import std.random, std.range;
		
    auto emptyBoxes = board.data.filter!(a => a == 0);
		emptyBoxes.drop(uniform(0, emptyBoxes.array.length)).front = uniform(1, 3)*2;
	}
	
	bool finished() const
	{
		import std.algorithm;
		// return when board is filled
		return !reduce!((sofar, x) => sofar || x == 0)(false, board.data);	
	}
	
	void printBoard() 
	{
		import std.stdio;
		
		writefln("Current board (%d X %d)", board.edgeLength, board.edgeLength);
		foreach(row; board.byVector(false))
		{
			writefln("%(%4d\t%)", row);
		}
	}
}

struct Board
{
	private uint[] data;
	private const size_t edgeLength;
	
	this(size_t boardSize)
	{
		data.length = boardSize*boardSize;
		edgeLength = boardSize;
	}
	
	auto getVector(bool isVertical, size_t i)
	{
		import std.range;
		return data.drop(isVertical? i : i*edgeLength).
			stride(isVertical? edgeLength : 1).
			take(edgeLength);
	}
	
	auto byVector(bool isVertical)
	{
		import std.range;
		return iota(edgeLength).map!(i => getVector(isVertical, i));
	}	
}

unittest
{
	
}
