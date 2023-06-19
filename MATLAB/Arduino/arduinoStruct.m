function XtoS = arduinoStruct(Xto, Aon, Bon, Con)
Delay=32e-6*length(Xto(:,1));
Multiplier = floor((16000000/(60*(sum(Xto(:,1))+Delay))));
ValueA = 16;
ValueB = 8;
ValueC = 4;
PORT = (ValueA + ValueB + ValueC)/2+(ValueA/2*Aon + ValueB/2*Bon + ValueC/2*Con);
for i = 1:length(Xto)
    switch Xto(i,2)
        case 1
            if Aon>0; PORT = PORT - ValueA; Aon = -1;
            else; PORT = PORT + ValueA; Aon = 1; end
        case 2
             if Bon>0; PORT = PORT - ValueB; Bon = -1;
             else; PORT = PORT + ValueB; Bon = 1; end
        case 3 
            if Con>0; PORT = PORT - ValueC; Con = -1;
            else; PORT = PORT + ValueC; Con = 1; end
    end
    Xto(i,3)=PORT;
end
Xto(:,3) = circshift(Xto(:,3),1);
XtoS = [round(Xto(:,1)*Multiplier) Xto(:,2) Xto(:,3)];

size = num2str(length(XtoS));

a=['int lim = ', num2str(str2double(size) - 1) ,'; \nstruct moment a[', size ,'] = {\n'];
for i = 1:numel(XtoS(:,1))
 a= [a, '{',  num2str(XtoS(i,1), '%d') , ',' , num2str(XtoS(i,3)) '},\n' ];
end
disp(["Comutações: " + length(XtoS)/3])
a = [a(1:end-3), "};"];
a = strjoin(a, '');
a=sprintf(a);
clipboard('copy',a);
disp(strjoin(["Máximo OCR1A:  " max(XtoS(:,1))]))
disp(strjoin(["Mínimo OCR1A:  " min(XtoS(:,1))]))
return
end
