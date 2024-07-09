function BlurOut = Blur(x, w0)

    x0 =(length(x))/2;
    w = exp(-(x-x0).^2./w0^2);
    xx = sum(w);
    w = [w w w];
    for ii =1:length(x)
        M(ii,:) = w(1,length(w)/2-ii:length(w)/2+length(x)-1-ii);
    end
    BlurOut = M./xx;

end