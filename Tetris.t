View.Set("graphics:300;600, offscreenonly")

var chars : array char of boolean

var startTime : int := Time.Elapsed

var grid : array 0 .. 9, 0 .. 18 of int


var rotateDone : boolean := true
var leftDone : boolean := true
var rightDone : boolean := true

type block : % Block data


record
    
    id : int
    x : int
    y : int
    
    dropped : boolean
    leftAble : boolean
    rightAble : boolean
    rotateAble : boolean
    
    rotateState : int
    
    bX : array 1 .. 3 of int
    bY : array 1 .. 3 of int
    
end record

var gamePiece : block

for i : 0 .. 9
    
    for j : 0 .. 18
        
        grid(i, j) := 0
        
    end for
        
end for
    
proc draw(x : int, y : int, col : int) % Draws box at specifed section and colour
    
    Draw.FillBox(x*30, y*30, x*30 + 30, y*30 + 30, black) % Draws outline
    
    Draw.FillBox(x*30 + 3, y*30 + 3, x*30 + 27, y*30 + 27, col) % Draws colour
    
end draw

proc updateField % Updates placed blocks
    
    cls
    
    for i : 0 .. 9
        
        for j : 0 .. 18
            
            case grid(i, j) of
                
            label 1 : draw(i, j, 42) % I Block
                
            label 2 : draw(i, j, 13) % L Block
                
            label 3 : draw(i, j, 9) % J Block
                
            label 4 : draw(i, j, 12) % O Block
                
            label 5 : draw(i, j, 11) % S Block
                
            label 6 : draw(i, j, 14) % T Block
                
            label 7 : draw(i, j, 10) % Z Block
                
            label :
                
            end case
            
        end for
            
    end for
        
    View.Update
    
end updateField

proc createObj % Creates a tetris piece
    
    gamePiece.dropped := false
    
    gamePiece.leftAble := true
    gamePiece.rightAble := true
    
    gamePiece.rotateAble := true
    
    gamePiece.id := Rand.Int(1, 7)
    
    % Sets coordinates of center block
    
    gamePiece.x := 4
    gamePiece.y := 18
    
    gamePiece.rotateState := 0
    
    case gamePiece.id of % Sets coordinates of other blocks relative to center block
        
    label 1 : % I Block
        
        gamePiece.bX(1) := -1
        gamePiece.bY(1) := 0
        
        gamePiece.bX(2) := 1
        gamePiece.bY(2) := 0
        
        
        gamePiece.bX(3) := 2
        gamePiece.bY(3) := 0
        
    label 2 : % L Block
        
        gamePiece.bX(1) := -1
        gamePiece.bY(1) := 0
        
        gamePiece.bX(2) := 1
        gamePiece.bY(2) := 0
        
        
        gamePiece.bX(3) := -1
        gamePiece.bY(3) := -1
        
    label 3 : % J Block
        
        gamePiece.bX(1) := -1
        gamePiece.bY(1) := 0
        
        gamePiece.bX(2) := 1
        gamePiece.bY(2) := 0
        
        
        gamePiece.bX(3) := 1
        gamePiece.bY(3) := -1
        
    label 4 :  % O Block
        
        gamePiece.bX(1) := 1
        gamePiece.bY(1) := 0
        
        gamePiece.bX(2) := 0
        gamePiece.bY(2) := -1
        
        
        gamePiece.bX(3) := 1
        gamePiece.bY(3) := -1
        
    label 5 :  % S Block
        
        gamePiece.bX(1) := 1
        gamePiece.bY(1) := 0
        
        gamePiece.bX(2) := -1
        gamePiece.bY(2) := -1
        
        
        gamePiece.bX(3) := 0
        gamePiece.bY(3) := -1
        
    label 6 :% T Block
        
        gamePiece.bX(1) := -1
        gamePiece.bY(1) := 0
        
        gamePiece.bX(2) := 1
        gamePiece.bY(2) := 0
        
        
        gamePiece.bX(3) := 0
        gamePiece.bY(3) := -1
        
    label 7 :  % Z Block
        
        gamePiece.bX(1) := -1
        gamePiece.bY(1) := 0
        
        gamePiece.bX(2) := 0
        gamePiece.bY(2) := -1
        
        
        gamePiece.bX(3) := 1
        gamePiece.bY(3) := -1
        
        
    end case
    
    
end createObj


proc drawObj % Draws a tetris piece
    
    % Imports game piece
    
    var x : int := gamePiece.x
    var y : int := gamePiece.y
    
    var id : int := gamePiece.id
    
    var bX : array 1 .. 3 of int := gamePiece.bX
    var bY : array 1 .. 3 of int := gamePiece.bY
    
    grid(x,y) := id
    
    for i : 1 .. 3
        
        x := x + bX(i)
        y := y + bY(i)
        
        
        grid (x,y) := id
        
        x  := gamePiece.x
        y := gamePiece.y
        
    end for
        
end drawObj

function checkAround(x : int, y : int) : boolean % Checks if the block around is part of the game piece (Returns false if it is)
    
    
    var a : int := gamePiece.x
    var b : int := gamePiece.y
    
    if x = a and y = b then
        
        result false
        
    end if
    
    for i : 1 .. 3
        
        if x = (a + gamePiece.bX(i)) and y = (b + gamePiece.bY(i)) then
            
            result false            
            
        end if
        
    end for
        
    result true
    
end checkAround

function checkBounds(x : int, y : int) : boolean% Checks if transformation is out of boundaries
    
    if x < 0 or y < 0 or x > 9 or y > 18 then
        
        result true
        
    end if
    
    for i : 1 .. 3 
        
        if x + gamePiece.bX(i) < 0 or y + gamePiece.bY(i) < 0 or x + gamePiece.bX(i) > 9 or y + gamePiece.bY(i) > 18 then
            
            result true
            
        end if
        
    end for
        
    result false
    
end checkBounds

proc dropObj % Checks if piece and drop and drops it if possible
    
    % Imports game piece
    
    var x : int := gamePiece.x
    var y : int := gamePiece.y
    
    var id : int := gamePiece.id
    
    var bX : array 1 .. 3 of int := gamePiece.bX
    var bY : array 1 .. 3 of int := gamePiece.bY
    
    
    if checkBounds(x, y - 1) then
        
        gamePiece.dropped := true
        
    end if
    
    if not(gamePiece.dropped) then
        
        if grid(x, y - 1) not= 0 and checkAround(x, y - 1) then
            
            gamePiece.dropped := true
            
            
        else
            
            for i : 1 .. 3
                
                if grid(x + bX(i), y + bY(i) - 1) not=0 and checkAround (x + bX(i), y + bY(i) - 1) then
                    
                    gamePiece.dropped := true
                    
                end if
                
            end for
                
        end if
        
    end if
    
    
    if gamePiece.dropped = false then
        
        gamePiece.y -= 1
        
        for i : 1 .. 3
            
            grid(x + gamePiece.bX(i),gamePiece.y + 1 + gamePiece.bY(i)) := 0
            
        end for
            
        grid(x,gamePiece.y + 1) := 0
        
        grid(x,gamePiece.y) := id
        
        for i : 1 .. 3
            
            grid(x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := id
            
        end for
            
    end if
    
end dropObj

proc moveLeft
    
    % Imports game piece
    
    var x : int := gamePiece.x
    var y : int := gamePiece.y
    
    var id : int := gamePiece.id
    
    var bX : array 1 .. 3 of int := gamePiece.bX
    var bY : array 1 .. 3 of int := gamePiece.bY
    
    gamePiece.leftAble := true
    
    if checkBounds(x-1, y) then
        
        gamePiece.leftAble := false
        
    end if
    
    if gamePiece.leftAble then
        
        if grid(x - 1, y) not= 0 and checkAround(x - 1, y) then
            
            gamePiece.leftAble := false    
            
        else
            
            for i : 1 .. 3
                
                if grid(x + bX(i) - 1, y + bY(i)) not= 0 and checkAround (x + bX(i) - 1, y + bY(i)) then
                    
                    gamePiece.leftAble := false
                    
                end if
                
            end for
                
        end if
        
    end if
    
    
    if gamePiece.leftAble then
        
        gamePiece.x -= 1
        
        for i : 1 .. 3
            
            grid(gamePiece.x + 1 + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := 0
            
        end for
            
        grid(gamePiece.x + 1,gamePiece.y) := 0
        
        grid(gamePiece.x,gamePiece.y) := id
        
        for i : 1 .. 3
            
            grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := id
            
        end for
            
    end if
    
end moveLeft

proc moveRight
    
    % Imports game piece
    
    var x : int := gamePiece.x
    var y : int := gamePiece.y
    
    var id : int := gamePiece.id
    
    var bX : array 1 .. 3 of int := gamePiece.bX
    var bY : array 1 .. 3 of int := gamePiece.bY
    
    gamePiece.leftAble := true
    
    if checkBounds(x + 1, y) then
        
        gamePiece.leftAble := false
        
    end if
    
    if gamePiece.leftAble then
        
        if grid(x + 1, y) not= 0 and checkAround(x + 1, y) then
            
            gamePiece.leftAble := false    
            
        else
            
            for i : 1 .. 3
                
                if grid(x + bX(i) + 1, y + bY(i)) not= 0 and checkAround (x + bX(i) + 1, y + bY(i)) then
                    
                    gamePiece.leftAble := false
                    
                end if
                
            end for
                
        end if
        
    end if
    
    
    if gamePiece.leftAble then
        
        gamePiece.x += 1
        
        for i : 1 .. 3
            
            grid(gamePiece.x - 1 + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := 0
            
        end for
            
        grid(gamePiece.x - 1,gamePiece.y) := 0
        
        grid(gamePiece.x,gamePiece.y) := id
        
        for i : 1 .. 3
            
            grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := id
            
        end for
            
    end if
    
end moveRight

proc rotate
    
    % Imports game piece
    
    var x : int := gamePiece.x
    var y : int := gamePiece.y
    
    var id : int := gamePiece.id
    
    var bX : array 1 .. 3 of int := gamePiece.bX
    var bY : array 1 .. 3 of int := gamePiece.bY
    
    gamePiece.rotateAble := true
    
    case id of
        
    label 1, 5 : % I and S Block
        
        case gamePiece.rotateState of
            
        label 0:
            for i : 1 .. 3 
                if checkBounds(x + bY(i), y - bX(i)) then
                    gamePiece.rotateAble := false
                end if
            end for
                if gamePiece.rotateAble then
                for i : 1 .. 3
                    if grid(x + bY(i), y - bX(i)) not= 0 and checkAround (x + bY(i), y - bX(i)) then
                        
                        gamePiece.rotateAble := false
                        
                    end if
                    
                end for
                    
            end if
            
            if gamePiece.rotateAble then
                
                for i : 1 .. 3
                    
                    grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := 0
                    
                    var temp : int := gamePiece.bX(i)
                    
                    gamePiece.bX(i) := gamePiece.bY(i) 
                    
                    gamePiece.bY(i) := -temp
                    
                end for
                    
                for i : 1 .. 3
                    
                    grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := id
                    
                end for
                    
                gamePiece.rotateState := 1 
                
            end if
            
            
            
            
        label 1 :
            
            for i : 1 .. 3 
                
                if checkBounds(x - bY(i), y + bX(i)) then
                    
                    gamePiece.rotateAble := false
                    
                end if
                
            end for
                
            if gamePiece.rotateAble then
                
                for i : 1 .. 3
                    
                    if grid(x - bY(i), y + bX(i)) not= 0 and checkAround (x - bY(i), y + bX(i)) then
                        
                        gamePiece.rotateAble := false
                        
                    end if
                    
                end for
                    
            end if
            
            if gamePiece.rotateAble then
                
                for i : 1 .. 3
                    
                    grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := 0
                    
                    var temp : int := gamePiece.bX(i)
                    
                    gamePiece.bX(i) := -gamePiece.bY(i) 
                    
                    gamePiece.bY(i) := temp
                    
                end for
                    
                for i : 1 .. 3
                    
                    grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := id
                    
                end for
                    
                gamePiece.rotateState := 0 
                
            end if
            
        end case
        
    label 2, 3, 6 : % T, L and J Block
        
        case gamePiece.rotateState of
            
             label 0 :
            
            for i : 1 .. 3 
                
                if checkBounds(x + bY(i), y - bX(i)) then
                    
                    gamePiece.rotateAble := false
                    
                end if
                
            end for
                
            if gamePiece.rotateAble then
                
                for i : 1 .. 3
                    
                    if grid(x + bY(i), y - bX(i)) not= 0 and checkAround (x + bY(i), y - bX(i)) then
                        
                        gamePiece.rotateAble := false
                        
                    end if
                    
                end for
                    
            end if
            
            if gamePiece.rotateAble then
                
                for i : 1 .. 3
                    
                    grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := 0
                    
                    var temp : int := gamePiece.bX(i)
                    
                    gamePiece.bX(i) := gamePiece.bY(i) 
                    
                    gamePiece.bY(i) := -temp
                    
                end for
                    
                for i : 1 .. 3
                    
                    grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := id
                    
                end for

                gamePiece.rotateState := 0
                
            end if
            
        label 1 :
            
            if checkBounds(x, y - 1) then
                
                gamePiece.rotateAble := false
                
            end if
            
            for i : 1 .. 3 
                
                if checkBounds(x + bY(i), y - bX(i) - 1) then
                    
                    gamePiece.rotateAble := false
                    
                end if
                
            end for
                
            if gamePiece.rotateAble then
                
                if grid(x, y  - 1) not= 0 and checkAround (x, y- 1) then
                    
                    gamePiece.rotateAble := false
                    
                end if
                
                for i : 1 .. 3
                    
                    if grid(x + bY(i), y - bX(i) - 1) not= 0 and checkAround (x + bY(i), y - bX(i) - 1) then
                        
                        gamePiece.rotateAble := false
                        
                    end if
                    
                end for
                    
            end if
            
            if gamePiece.rotateAble then
                
                grid(x, y) := 0
                
                for i : 1 .. 3
                    
                    grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := 0
                    
                    var temp : int := gamePiece.bX(i)
                    
                    gamePiece.bX(i) := gamePiece.bY(i) 
                    
                    gamePiece.bY(i) := -temp
                    
                end for
                    
                gamePiece.y -= 1
                
                grid(x, gamePiece.y) := id
                
                for i : 1 .. 3
                    
                    grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := id
                    
                end for
                    
                gamePiece.rotateState := 1 
                
            end if
            
        label 2:
            
             if checkBounds(x, y + 1) then
                
                gamePiece.rotateAble := false
                
            end if
            
            for i : 1 .. 3 
                
                if checkBounds(x + bY(i), y - bX(i) + 1) then
                    
                    gamePiece.rotateAble := false
                    
                end if
                
            end for
                
            if gamePiece.rotateAble then
                
                if grid(x, y  + 1) not= 0 and checkAround (x, y+  1) then
                    
                    gamePiece.rotateAble := false
                    
                end if
                
                for i : 1 .. 3
                    
                    if grid(x + bY(i), y - bX(i) + 1) not= 0 and checkAround (x + bY(i), y - bX(i) + 1) then
                        
                        gamePiece.rotateAble := false
                        
                    end if
                    
                end for
                    
            end if
            
            if gamePiece.rotateAble then
                
                grid(x, y) := 0
                
                for i : 1 .. 3
                    
                    grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := 0
                    
                    var temp : int := gamePiece.bX(i)
                    
                    gamePiece.bX(i) := gamePiece.bY(i) 
                    
                    gamePiece.bY(i) := -temp
                    
                end for
                    
                gamePiece.y += 1
                
                grid(x, gamePiece.y) := id
                
                for i : 1 .. 3
                    
                    grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := id
                    
                end for
                    
                gamePiece.rotateState := 0
                
            end if
            
        end case
        
    label 4 : % O Block (no rotation)

    label 7 : % Z Block
    
    case gamePiece.rotateState of
            
        label 0:
        
        if checkBounds(x + 1, y) then
                    gamePiece.rotateAble := false
                end if
        
            for i : 1 .. 3 
                if checkBounds(x + bY(i) + 1, y - bX(i)) then
                    gamePiece.rotateAble := false
                end if
            end for
                if gamePiece.rotateAble then
                
                if grid(x + 1, y) not = 0 and checkAround (x + 1, y ) then
                    gamePiece.rotateAble := false
                end if
                
                for i : 1 .. 3
                    if grid(x + bY(i) + 1, y - bX(i)) not= 0 and checkAround (x + bY(i) + 1, y - bX(i)) then
                        
                        gamePiece.rotateAble := false
                        
                    end if
                    
                end for
                    
            end if
            
            if gamePiece.rotateAble then
                
                for i : 1 .. 3
                    
                    grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := 0
                    
                    var temp : int := gamePiece.bX(i)
                    
                    gamePiece.bX(i) := gamePiece.bY(i) 
                    
                    gamePiece.bY(i) := -temp
                    
                end for
                
                grid(x, y) := 0
                
                gamePiece.x += 1
                
                grid(gamePiece.x, y) := id
                    
                for i : 1 .. 3
                    
                    grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := id
                    
                end for
                    
                gamePiece.rotateState := 1 
                
            end if
            
            
            
            
        label 1 :
        
         if checkBounds(x - 1, y) then
                    gamePiece.rotateAble := false
                end if
            
            for i : 1 .. 3 
                
                if checkBounds(x - bY(i) - 1, y + bX(i)) then
                    
                    gamePiece.rotateAble := false
                    
                end if
                
            end for
                
            if gamePiece.rotateAble then
            
            if grid(x- 1, y) not = 0 and checkAround (x - 1, y ) then
                    gamePiece.rotateAble := false
                end if
                
                for i : 1 .. 3
                    
                    if grid(x - bY(i) -1 , y + bX(i)) not= 0 and checkAround (x - bY(i) - 1, y + bX(i)) then
                        
                        gamePiece.rotateAble := false
                        
                    end if
                    
                end for
                    
            end if
            
            if gamePiece.rotateAble then
                
                for i : 1 .. 3
                    
                    grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := 0
                    
                    var temp : int := gamePiece.bX(i)
                    
                    gamePiece.bX(i) := -gamePiece.bY(i) 
                    
                    gamePiece.bY(i) := temp
                    
                end for
                
                grid (x, y) := 0
                
                gamePiece.x -= 1
                
                grid (gamePiece.x, y) := id
                    
                for i : 1 .. 3
                    
                    grid(gamePiece.x + gamePiece.bX(i),gamePiece.y + gamePiece.bY(i)) := id
                    
                end for
                    
                gamePiece.rotateState := 0 
                
            end if
            
        end case
        
    end case
    
end rotate

proc getInput
    
    Input.KeyDown (chars)
    
    if chars (KEY_RIGHT_ARROW) then
        
        if rightDone then
        
        moveRight
        
        rightDone := false
        
        end if
        
    else
    
    rightDone := true
    
    end if
    
    if chars (KEY_LEFT_ARROW) then
        
        if leftDone then
        
        moveLeft
        
        leftDone := false
        
        end if
        
    else
    
    leftDone := true
    
    end if
    
    if chars (KEY_DOWN_ARROW) then

        dropObj

    end if
    
    if chars (KEY_UP_ARROW) then
        
        if rotateDone then
        
        rotate
        
        rotateDone := false
        
        end if
        
    else
    
    rotateDone := true
    
    end if
    
end getInput

createObj

loop % Main loop
    
    getInput
    
    drawObj
    updateField 
    
    if Time.Elapsed - startTime >= 1000 then
        
        startTime := Time.Elapsed
        
        dropObj
        
    end if
    
    if gamePiece.dropped then
        
        createObj
        
    end if
    
    delay(10)
    
end loop