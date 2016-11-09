Sub Screw
    'Variables - edit here. All in mm.
    d = 5 'Inner diameter
    w = 0.1525 'Trace width
    s = 0.1525 'Trace spacing
    N = 9 'Turns
    L = 4 ' Number of layers (max 4, if you need more, edit the below if statement to your preferred layers)


    'Don't touch
    Dim  Board
    Dim  Arc
    pi = 3.14159265359
    Xstart = 100  'starting coordinates
    Ystart = 100  'starting coordinates

    Set Board = PCBServer.GetCurrentPCBBoard
    If Board is Nothing Then Exit Sub

    da = 45 '45 degree arcs, 8 is a full turn
    ds = s/8 + w/8

    for j = 1 to L
        R = d / 2
        a = 0
        if (j = 1) or (j = 3) then 'coil should turn clockwise
           clockwise = false
           degree_offset = 0
        else
            clockwise = true
            degree_offset = 180
        end if

        for i = 1 to (N*360/da)
            'set the center point for the arc:
            X = sqrt(2)*ds*sin(((degree_offset-a)*pi/180))  'magic
            Y = sqrt(2)*ds*cos(((degree_offset-a)*pi/180))

            'draw the arc:
            Arc           = PCBServer.PCBObjectFactory(eArcObject, eNoDimension, eCreate_Default)

            if j = 1 then Arc.Layer = eTopLayer
            if j = 2 then Arc.Layer = eMidLayer2
            if j = 3 then Arc.Layer = eMidLayer1
            if j = 4 then Arc.Layer = eBottomLayer

            Arc.XCenter   = MmsToCoord(Xstart + X)
            Arc.YCenter   = MmsToCoord(Ystart + Y)
            Arc.Radius    = MmsToCoord(R)
            Arc.LineWidth = MmsToCoord(w)
            if clockwise then
               Arc.StartAngle = a - da
               Arc.EndAngle = a
            else
               Arc.StartAngle = a
               Arc.EndAngle = a + da
            end if
            Board.AddPCBObject(Arc)

            if clockwise then 'increase the angle
               a = a - da
            else
                a = a + da
            end if

            R = R + ds 'increase the radius for every arc

        next
    next

End Sub
