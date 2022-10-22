function [D]=NLM_FILTER(J,Sigma,h)
%% NLM parameters
D = zeros(size(J));
ssize = 21;
ksize = 7;
[JP,hs,hp]=PADDING(J,ssize,ksize);
[m,n] = size(JP);
for i = hs+1:m-hs
    for j = hs+1:n-hs        
        sw = JP(i-hs:i+hs,j-hs:j+hs);
        rp = JP(i-hp:i+hp,j-hp:j+hp);
        swcol = im2col(sw,[ksize,ksize],'sliding');
        pixels = swcol(floor((ksize^2)/2)+1,:);
        rpcol = reshape(rp,1,ksize^2)';
        d = (bsxfun(@minus,swcol,rpcol)).^2;
        d = sum(d,1)./(ksize*ksize);
        w = exp(-d./(2*h*h));
        nw = w./sum(w);
        D(i-hs,j-hs) = sum(pixels.*nw);

    end
end

end