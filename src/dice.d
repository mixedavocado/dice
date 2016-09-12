
import std.stdio,std.string,std.conv;
import std.regex,std.random,std.math;
import std.algorithm,std.array;

void main( in string[] args ){

	if ( args.length <= 1 ){
		writeln("Dice program.");
		writeln("[input format]\n (%d)d(%d)+(%d)");
		writeln("[example]\n ",args[0]," 6 2d6 2d6+10");
	} 
	
	auto pattern1 = regex(r"(\d+)d(\d+)\+(\d+)");
	auto pattern2 = regex(r"(\d+)d(\d+)");
	auto pattern3 = regex(r"(\d)");
	
	foreach( arg ; args[1..$] )
	{
		auto m = arg.matchFirst(pattern1);
		m = (m) ? m : arg.matchFirst(pattern2);
		m = (m) ? m : arg.matchFirst(pattern3);
		if( !m ){continue;}
		debug writeln("[Debug] m; ",m);
		
		auto dice = Dice!size_t( m.array()[1..$].trans!size_t() );
		
		writefln(
			" %6s ; %s ( %s .. %s ; ave %s )"
			,dice.take()
			,m[0]
			,dice.min
			,dice.max
			,dice.ave
			);
	}
	return;
}

union Dice( T )
{
	T[] val;
	
	this( in T[] args ... )
	{
		debug writefln("[Debug] Dice.this(%s); ",args);
		switch( args.length ){
			case 1:
				val = [1,args[0],0];
				break;
			case 2:
				val = [args[0],args[1],0];
				break;
			case 3:
				val = [args[0],args[1],args[2]];
				break;
			default:
				throw new Exception("Does NOT expected arguments!");
		}
		return;
	}
	
	real take()
	{
		real ret = val[2];
		foreach( i ; 0..val[0] )
			ret += uniform(1,val[1]);
		return ret;
	}
	/*string toString()
	{
		return val[0].to!string()~"d"~val[1];
	}*/
	real max() @property @safe pure nothrow @nogc
	{
		return cast(real)val[0]*val[1]+val[2];
	}
	real min() @property @safe pure nothrow @nogc
	{
		return cast(real)val[0]*1+val[2];
	}
	real ave() @property @safe pure nothrow @nogc
	{
		return cast(real)(val[0]*(1+val[1]))/2+val[2];
	}
}
unittest{
	auto dice = Dice!long(2,6,10);
	assert( dice.min == 12 );
	assert( dice.max == 22 );
	assert( dice.ave == 17 );
}

R[] trans( R , T = string )( in T[] args ) pure
{
	R[] ret = new R[](args.length);
	foreach( i ; 0..args.length )
		ret[i] = args[i].to!R();
	return ret;
}


