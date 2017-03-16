prompt='Please enter the name of the .mat file to plot from: ';
x=input(prompt,'s');
load(x);
clear prompt x
varNames=who;
zzznumVars=(length(varNames));
areas=cell((zzznumVars/2),1);
pressures=cell((zzznumVars/2),1);

%this block separates the workspace variables into two vectors, one for the
%areas and one for the pressures

%for the sake of simplicity, making the assumption that there are no
%variables in the workspace besides areas and pressures, denoted A*** and
%P***

areaexp = 'A\w*';
pressureexp = 'P\w*';
areaCounter=1;
pressureCounter=1;

for n=1:length(varNames)
    str=varNames{n};
    if isempty(regexp(varNames{n},areaexp,'match'))
        pressures{pressureCounter}=string(str);
        pressureCounter=pressureCounter+1;
    else
        areas{areaCounter}=string(str);
        areaCounter=areaCounter+1;
    end
end

clear areaCounter areaexp n pressureCounter pressureexp str

%from here on, assuming that area and pressure vectors will have the same
%ordering -- i.e. they'll be named in such a way that two vectors, one
%containing the area info and the other the pressure, will match up. also
%assuming that the loaded .mat file is non-emtpy

for n=1:(zzznumVars/2)
   figure;
   plot(eval(char(areas{n})),eval(char(pressures{n})));
   title(areas{n});
end

%importdata('DPPC_Nacetyl_030317','\t',3)

clear varNames