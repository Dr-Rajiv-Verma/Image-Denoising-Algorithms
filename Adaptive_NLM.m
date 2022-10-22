function [DImg]=Adaptive_NLM(J,SWmap,ksize,Sigma)
[m,n] = size(J);
DImg = zeros(m,n);
for i = 1:m
    for j = 1:n
        ssize = SWmap(i,j);
        if ssize == 21
            h = 0.7*Sigma;
        elseif ssize == 15
            h = 0.7*Sigma;
        elseif ssize == 9
            h = 1.1*Sigma;
        end
        [JP,hs,hp] = PADDING(J,ssize,ksize);
        pr = i+hs; 
        pc = j+hs;
        sw = JP(pr-hs:pr+hs,pc-hs:pc+hs);
        rp = JP(pr-hp:pr+hp,pc-hp:pc+hp);
        swcol = im2col(sw,[ksize,ksize],'sliding');
        pixels = swcol(floor((ksize^2)/2)+1,:);
        rpcol = reshape(rp,1,ksize^2)';
        d = (bsxfun(@minus,swcol,rpcol)).^2;
        d = sum(d,1)./(ksize*ksize);
        w = exp(-d./(2*h*h));
        nw = w./sum(w);
        DImg(i,j) = sum(pixels.*nw);
        
    end
end
end