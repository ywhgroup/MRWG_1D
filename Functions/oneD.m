function GeometryOut = oneD(PatternIn, rr)

    Period = 870;
    xlength = Period/length(PatternIn);
    xplus = 0;
    for ii =1:length(PatternIn)
        xplus = xplus + xlength;
        XGrid(ii) = xplus;
    end
    [Nx, Ny] = size(PatternIn);
    Geometry = [];
    for jj = 1:Ny
        if rr == 1
            Geometry(jj) = XGrid(jj);
        elseif rr == 2
            Geometry(jj) = PatternIn(1,jj);
        end
    end
    GeometryOut = Geometry;
    
end

