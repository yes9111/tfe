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
		insertBox(Direction.Left);
		insertBox(Direction.Up);
	}
	
	void shift(Direction direction)()
	{
		import std.algorithm, std.array, std.range;
		
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
		insertBox(direction);
	}
	
	void insertBox(Direction direction)
	{
		import std.random, std.range;
		
		bool getVertical = !direction.isVertical;
		int vectorIndex = direction.isNegative ? board.edgeLength-1 : 0;
		
		auto emptyBoxes = board.getVector(getVertical, vectorIndex).filter!(a => a == 0);
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
	private immutable int edgeLength;
	
	this(size_t boardSize)
	{
		data.length = boardSize*boardSize;
		edgeLength = boardSize;
	}
	
	auto getVector(bool isVertical, int i)
	{
		import std.range;
		return data.drop(isVertical? i : i*edgeLength).
			stride(isVertical? edgeLength : 1).
			take(edgeLength);
	}
	
	auto byVector(bool isVertical = true)
	{
		import std.range;
		return iota(edgeLength).map!(i => getVector(isVertical, i));
	}	
}

unittest
{
	
}
