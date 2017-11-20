function coord = dehomo(homoCoord)
    dim = size(homoCoord, 2) - 1;
    normCoord = bsxfun(@rdivide,homoCoord,homoCoord(:,end));
    coord = normCoord(:,1:dim);
end