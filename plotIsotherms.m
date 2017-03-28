%make sure to navigate to the folder where the files to plot are first, the
%program doesn't do that!

%also, as written, this script cannot match titles to more than 9 isotherms
%at once, so keep that in mind

temp=dir;
zzznames=cell((length(temp)-2),1);
counter=1;  %for getting the names to match plots
for n=3:length(temp)
   tempname=temp(n).name; 
   tempnum=length(tempname)-5;  %pull index of date from filename
   isDupe=tempnum-2;
   datename=tempname(tempnum:length(tempname)); %store date
   dupeName=tempname(isDupe:length(tempname)); %store date with possibility of duplicate
   if double(dupeName(1))>57 %57 is the ascii code for 9
       [C,~]=importdata(tempname);
       eval(['A' datename '_' num2str(counter) '= str2double(C.textdata(4:length(C.textdata),2));']);
       eval(['P' datename '_' num2str(counter) '= str2double(C.textdata(4:length(C.textdata),3));']);
       counter=counter+1;
   else
       [C,~]=importdata(tempname);
       eval(['A_' dupeName(1) '_' datename '_' num2str(counter) '= str2double(C.textdata(4:length(C.textdata),2));']);
       eval(['P_' dupeName(1) '_' datename '_' num2str(counter) '= str2double(C.textdata(4:length(C.textdata),3));']);
       counter=counter+1;
   end
   zzznames(n-2)=strcat(strtrim(C.textdata(2,1)),{' '},strtrim(C.textdata(2,7)),{' '},datename,{' Trial '});
end

clear tempname tempnum datename C n temp isDupe dupeName counter

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

%error with plot is that the data type is cell and not num
for n=1:(zzznumVars/2)
   figure;
   xname=char(areas{n});
   yname=char(pressures{n});
   temp=length(xname);  %pull the index of the character representing the global index
   trialnum=1;          %by default assume first trial
   if temp>9            %if not first trial, pull trial number for title
       trialnum=xname(3);
   end
   indexy=xname(temp);  %pull value of the global index
   xvalues=eval(xname);
   yvalues=eval(yname);
   plot(xvalues,yvalues);
   title(strcat(zzznames{str2double(indexy)},{' '},num2str(trialnum)));
   xlabel('area ($\rm{\AA}^2$/molecule)','interpreter','latex');
   ylabel('surface pressure (mN/m)','interpreter','latex');
   %saveas(gcf,
end

clear varNames n zzznumVars xvalues yvalues temp xname yname zzznames indexy areas pressures