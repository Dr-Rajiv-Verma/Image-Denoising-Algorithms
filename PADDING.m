function [IP,hs,hp]=PADDING(I,S,P)
hp=floor(P/2);                                            % half patch size
hs=floor(S/2);                                    % half search window size
[M,N]=size(I);
IP=zeros(M+S-1,N+S-1);
IP(hs+1:M+hs,hs+1:N+hs)=I;
IP(1:hs,:)=IP(S:-1:hs+2,:);
IP(M+hs+1:M+S-1,:)=IP(M+hs-1:-1:M,:);
IP(:,1:hs)=IP(:,S:-1:hs+2);
IP(:,N+hs+1:N+S-1)=IP(:,N+hs-1:-1:N);
end