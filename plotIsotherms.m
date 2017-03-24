%make sure to navigate to the folder where the files to plot are first, the
%program doesn't do that!

temp=dir;
zzznames=cell((length(temp)-2),1);
for n=3:length(temp)
   tempname=temp(n).name; 
   tempnum=length(tempname)-5;  %pull index of date from filename
   isDupe=tempnum-2;
   datename=tempname(tempnum:length(tempname)); %store date
   dupeName=tempname(isDupe:length(tempname)); %store date with possibility of duplicate
   if double(dupeName(1))>57 %57 is the ascii code for 9
       [C,~]=importdata(tempname);
       eval(['A' datename '= C.textdata(4:length(C.textdata),2);']);
       eval(['P' datename '= C.textdata(4:length(C.textdata),3);']);
   else
       [C,~]=importdata(tempname);
       eval(['A_' dupeName(1) '_' datename '= C.textdata(4:length(C.textdata),2);']);
       eval(['P_' dupeName(1) '_' datename '= C.textdata(4:length(C.textdata),3);']);
   end
   zzznames(n-2)=strcat(strtrim(C.textdata(2,1)),{' '},strtrim(C.textdata(2,7)));
end

clear tempname tempnum datename C n temp isDupe dupeName

varNames=who;
zzznumVars=(length(varNames)-1);
areas=cell((zzznumVars/2),1);
pressures=cell((zzznumVars/2),1);

%this block separates the workspace variables into two vectors, one for the
%areas and one for the pressures

%for the sake of simplicity, making the assumption that there are no
%variables in the workspace besides areas and pressures, denoted A*** and
%P***

areaexp = 'A\w*';
areaCounter=1;
pressureCounter=1;

for n=1:(length(varNames)-1)
    str=varNames{n};
    if isempty(regexp(varNames{n},areaexp,'match'))
        pressures{pressureCounter}=string(str);
        pressureCounter=pressureCounter+1;
    else
        areas{areaCounter}=string(str);
        areaCounter=areaCounter+1;
    end
end

clear areaCounter areaexp n pressureCounter str

%from here on, assuming that area and pressure vectors will have the same
%ordering -- i.e. they'll be named in such a way that two vectors, one
%containing the area info and the other the pressure, will match up. also
%assuming that the loaded .mat file is non-emtpy

for n=1:(zzznumVars/2)
   figure;
   plot(eval(char(areas{n})),eval(char(pressures{n})));
   title(areas{n});
   xlabel('area ($\rm{\AA}^2$/molecule)','interpreter','latex');
   ylabel('surface pressure (mN/m)','interpreter','latex');
end

clear varNames n zzznumVars