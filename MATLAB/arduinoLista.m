function arduinoLista(Xto)
XtoS =  mat2cell(Xto,[numel(Xto(:,1))],[1,1,1] );
XtoS{3} = string(XtoS{3});
XtoS{3} = replace(XtoS{3}, "1", "Ma");
XtoS{3} = replace(XtoS{3}, "2", "Mb");
XtoS{3} = replace(XtoS{3}, "3", "Mc");

size = num2str(numel(XtoS{1}));
a=['Moments moment[] = { \n'];
for i = 1:numel(XtoS{1}(:,1));
 a= [a, '{',  num2str(XtoS{1}(i), '%.8f') , ',' , XtoS{2}(i) , ',', XtoS{3}(i) , ', &moment[', i ,']},\n' ];
end
a = [a(1:end-2), "0]} \n};"];
a = strjoin(a, '');
a=sprintf(a);
clipboard('copy',a);
end
