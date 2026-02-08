// Utility function to find ground Z at a position
// Returns true and sets outPos if ground was found, false otherwise
function r_FindGroundZ(pos : Vector, out outPos : Vector) : bool {
    var x : float;
    var traceStart, traceEnd, normal : Vector;
    
    outPos = pos;
    
    // Try NavigationComputeZ first
    if (theGame.GetWorld().NavigationComputeZ(pos, -500.0, 1000.0, x)) {
        outPos.Z = x + 1.5;
        return true;
    }
    
    // Fallback to StaticTrace
    traceStart = pos;
    traceStart.Z = 1000.0;
    traceEnd = pos;
    traceEnd.Z = -200.0;
    
    if (theGame.GetWorld().StaticTrace(traceStart, traceEnd, outPos, normal)) {
        outPos.Z += 1.5;
        return true;
    }
    
    return false;
}
