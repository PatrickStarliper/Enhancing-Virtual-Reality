%NAE Grand Challenge Group 2
%Version: Pre-Release 1.0
%************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************%
%Background Information/Moores Law

clc;clear;close all

%Load/Inputs
cores=xlsread('40years-cores.xlsx');
frequency=xlsread('40years-frequency.xlsx');
specint=xlsread('40years-specint.xlsx');
transistors=xlsread('40years-transistors.xlsx');
watts=xlsread('40years-watts.xlsx');
[cost,name]=xlsread('Cost.xlsx');
[r,c]=size(cost);
InternetCost=xlsread('InternetCost.xlsx');
internetSpeedCost=mean(InternetCost(:))*25;
CloudCost=12;

%Data Validation/Removal of NaN
coresNaN=isnan(cores(:,1));
frequencyNaN=isnan(frequency(:,1));
specintNaN=isnan(specint(:,1));
transistorsNaN=isnan(transistors(:,1));
wattsNaN=isnan(watts(:,1));

cores(coresNaN,:)=[];
frequency(frequencyNaN,:)=[];
specint(specintNaN,:)=[];
transistors(transistorsNaN,:)=[];
watts(wattsNaN,:)=[];

%Plot Data
hold on
grid on

%Plotting Cores and Curve
[xData3, yData3] = prepareCurveData( cores(:,1), cores(:,2));
ft3 = fittype( 'exp2' );
opts3 = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts3.Display = 'Off';
opts3.Normalize = 'on';
opts3.Robust = 'Bisquare';
opts3.StartPoint = [0 0 0 0];
[fitresult3, gof3] = fit( xData3, yData3, ft3, opts3 );
plot( fitresult3,'b', xData3, yData3,'bo' );

%Plotting Frequency and Curve
[xData, yData] = prepareCurveData( frequency(:,1), frequency(:,2) );
ft = fittype( 'exp2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.Normalize = 'on';
opts.Robust = 'Bisquare';
opts.StartPoint = [-512.678531315517 2.9709205885514 1322.83354475045 2.30782176579733];
[fitresult, gof] = fit( xData, yData, ft, opts );
plot( fitresult,'g', xData, yData ,'gx');

%Plotting Transistors and Curve
[xData2, yData2] = prepareCurveData( transistors(:,1), transistors(:,2));
ft2 = fittype( 'exp2' );
opts2 = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts2.Display = 'Off';
opts2.Normalize = 'on';
opts2.StartPoint = [4474.19024604189 2.65952360061586 2931.39814872508 4.90646160890292];
[fitresult2, gof2] = fit( xData2, yData2, ft2, opts2 );
tranTrend=plot( fitresult2,'m', xData2, yData2,'m*');

%Plotting SpecINT and Curve
[xData4, yData4] = prepareCurveData( specint(:,1), specint(:,2) );
ft4 = fittype( 'exp1' );
opts4 = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts4.Display = 'Off';
opts4.Normalize = 'on';
opts4.Robust = 'LAR';
opts4.StartPoint = [5337.20838475508 1.66513632677868];
[fitresult4, gof4] = fit( xData4, yData4, ft4, opts4 );
plot( fitresult4, 'r',xData4, yData4 ,'rd');

%Plotting Watts and Curve
[xData5, yData5] = prepareCurveData( watts(:,1), watts(:,2) );
ft5 = fittype( 'exp2' );
opts5 = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts5.Display = 'Off';
opts5.Normalize = 'on';
opts5.Robust = 'LAR';
opts5.StartPoint = [213.425247426066 1.42345226802044 -158.863541669664 1.55323701333799];
[fitresult5, gof5] = fit( xData5, yData5, ft5, opts5 );
plot( fitresult5,'c', xData5, yData5,'cd' );

%Lengend
lgd=legend('Cores','Cores Fit','Frequency [MHz]','Frequency Fit','Transistors (In Thousands)','Transistors Fit','SpecINT','SpecINT Fit','Watts','Watts Fit','Location','northwest');
lgd.FontSize=12;

%Y-Scale set to LOG
set(gca, 'YScale', 'log')

%Placement of Window and Resolution
x0=10;
y0=10;
width=1280;
height=720;
set(gcf,'units','points','position',[x0,y0,width,height]);

%Title and Axis
xlabel('Year','FontSize',14);
title('Moore''s Law','FontSize',16);


%Removing Warning Messages
clc;

%More Information About Moore's Law?
moreInfo=menu('Do you like to know more about Moore''s Law?','Yes','No');
if(moreInfo==1)
    cond2=1;
while(cond2==1)
    %More menus/inputs/calculations needed here if User Selects Yes
    MooreCalc=menu('What do you like to know/do?','Average Change Over Years','Tracing Points','Add Data Values to Existing Data Sets');
    
    
        %Conditional Case Switch
        if(MooreCalc==1)
            MooreWhich=menu('Which data do you like to know more about?','Cores','Frequency','Transistors','SpecINT','Watts');
            %Conditional Case Switch
            if(MooreWhich==0)
                warning('User did not choose an option. Program will skip');
                cond2=0;
            elseif(MooreWhich==1)
                fprintf('Average change in Cores over the years')
                fprintf('\nPlease specifiy a range of years between %i and %i as a vector [x,y]: ',round(cores(1,1)),round(cores(end,1)));
                MooreVal=input('');
                %Find Year
                [R1,C1]=find(MooreVal(1)<=cores(:,1) & MooreVal(2)>=cores(:,1));
                %For Loop to Calculate Average Slope
                [polyM,polyB]=polyfit(cores(R1,1),log(cores(R1,2)),1);
                fprintf('The average change in cores between years %i and %i was: %0.4fx\n\n',MooreVal(1),MooreVal(2),exp(polyM(1)));
            elseif(MooreWhich==2)
                fprintf('Average change in Frequency over the years')
                fprintf('\nPlease specifiy a range of years between %i and %i as a vector [x,y]: ',round(frequency(1,1)),round(frequency(end,1)));
                MooreVal=input('');
                %Find Year
                [R1,C1]=find(MooreVal(1)<=frequency(:,1) & MooreVal(2)>=frequency(:,1));
                %For Loop to Calculate Average Slope
                x_poly=[1:length(R1)]';
                [polyM,polyB]=polyfit(x_poly,log(frequency(R1,2)),1);
                fprintf('The average change in frequency between years %i and %i was: %0.4fx\n\n',MooreVal(1),MooreVal(2),exp(polyM(1)));  
            elseif(MooreWhich==3)
                fprintf('\nAverage change in Transistors over the years')
                fprintf('\nPlease specifiy a range of years between %i and %i as a vector [x,y]: ',round(transistors(1,1)),round(transistors(end,1)));
                MooreVal=input('');
                %Find Year
                [R1,C1]=find(MooreVal(1)<=transistors(:,1) & MooreVal(2)>=transistors(:,1));
                %For Loop to Calculate Average Slope
                x_poly=[1:length(R1)]';
                [polyM,polyB]=polyfit(x_poly,log(transistors(R1,2)),1);
                fprintf('The average change in transistors between years %i and %i was: %0.4fx\n\n',MooreVal(1),MooreVal(2),exp(polyM(1)));
            elseif(MooreWhich==4)
                fprintf('\nAverage change in SpecINT over the years')
                fprintf('\nPlease specifiy a range of years between %i and %i as a vector [x,y]: ',round(specint(1,1)),round(specint(end,1)));
                MooreVal=input('');
                %Find Year
                [R1,C1]=find(MooreVal(1)<=specint(:,1) & MooreVal(2)>=specint(:,1));
                %For Loop to Calculate Average Slope
                x_poly=[1:length(R1)]';
                [polyM,polyB]=polyfit(x_poly,log(specint(R1,2)),1);
                fprintf('The average change in SpecINT performance between years %i and %i was: %0.4fx\n\n',MooreVal(1),MooreVal(2),exp(polyM(1)));
            else
                fprintf('\nAverage change in Watts over the years')
                fprintf('\nPlease specifiy a range of years between %i and %i as a vector [x,y]: ',round(watts(1,1)),round(watts(end,1)));
                MooreVal=input('');
                %Find Year
                [R1,C1]=find(MooreVal(1)<=watts(:,1) & MooreVal(2)>=watts(:,1));
                %For Loop to Calculate Average Slope
                x_poly=[1:length(R1)]';
                [polyM,polyB]=polyfit(x_poly,log(watts(R1,2)),1);
                fprintf('The average change in power consumption [Watts]  between years %i and %i was: %0.4fx\n\n',MooreVal(1),MooreVal(2),exp(polyM(1)));
            end
        elseif(MooreCalc==2)
            %Tracing Points
            MooreWhich2=menu('Which data do you like to know more about?','Cores','Frequency','Transistors','SpecINT','Watts');
            if(MooreWhich2==1)
                fprintf('\nPlease enter a year you would like to find between %i and %i: ',round(cores(1,1)),round(cores(end,1)));
                findyear=input('');
                [R2,C2]=find(findyear==round(cores(:,1)));
                Years=round(cores(R2,1));
                Value=round(cores(R2,2));
                if(length(R2)~=0)
                fprintf('\nYear\tCores');
                for(i=[1:length(R2)])
                    fprintf('\n%i\t%i',Years(i),Value(i));
                end
                else
                    warning('There were no values found.');
                end
            elseif(MooreWhich2==2)
                fprintf('\nPlease enter a year you would like to find between %i and %i: ',round(frequency(1,1)),round(frequency(end,1)));
                findyear=input('');
                 [R2,C2]=find(findyear==round(frequency(:,1)));
                Years=round(frequency(R2,1));
                Value=round(frequency(R2,2));
                if(length(R2)~=0)
                fprintf('\nYear\tFrequency [Mhz]');
                for(i=[1:length(R2)])
                    fprintf('\n%i\t%i',Years(i),Value(i));
                end
                else
                    warning('There were no values found.');
                end
            elseif(MooreWhich2==3)
                fprintf('\nPlease enter a year you would like to find between %i and %i: ',round(transistors(1,1)),round(transistors(end,1)));
                findyear=input('');
                 [R2,C2]=find(findyear==round(transistors(:,1)));
                Years=round(transistors(R2,1));
                Value=round(transistors(R2,2));
                if(length(R2)~=0)
                fprintf('\nYear\tTransistors (In Thousands)');
                for(i=[1:length(R2)])
                    fprintf('\n%i\t%i',Years(i),Value(i));
                end
                else
                    warning('There were no values found.');
                end
            elseif(MooreWhich2==4)
                fprintf('\nPlease enter a year you would like to find between %i and %i: ',round(specint(1,1)),round(specint(end,1)));
                findyear=input('');
                 [R2,C2]=find(findyear==round(specint(:,1)));
                Years=round(specint(R2,1));
                Value=round(specint(R2,2));
                if(length(R2)~=0)
                fprintf('\nYear\tSpecINT');
                for(i=[1:length(R2)])
                    fprintf('\n%i\t%i',Years(i),Value(i));
                end
                else
                    warning('There were no values found.');
                end
            elseif(MooreWhich2==5)
                fprintf('\nPlease enter a year you would like to find between %i and %i: ',round(watts(1,1)),round(watts(end,1)));
                findyear=input('');
                 [R2,C2]=find(findyear==round(watts(:,1)));
                Years=round(watts(R2,1));
                Value=round(watts(R2,2));
                if(length(R2)~=0)
                fprintf('\nYear\tWatts');
                for(i=[1:length(R2)])
                    fprintf('\n%i\t%i',Years(i),Value(i));
                end
                else
                    warning('There were no values found.');
                end
            else
                warning('User did not choose an option. Proceeding...');
            end
        elseif(MooreCalc==3)
            %Adding Data Values
            MooreWhich=menu('Which data doyou like to know more about?','Cores','Frequency','Transistors','SpecINT','Watts');
            if(MooreWhich==0)
                warning('User did not choose an option, Program will proceed.');
            elseif(MooreWhich==1)
                 %Cores
                 fprintf('\nPlease input the years as a vector (i.e. [2017;2018;2019]): ');
                 cores2=input('');
                 
                 cores3=input('Please input the corresponding values as a vector (i.e. [9;10;11]): ');
                 temp=[cores2,cores3];
                 cores=[cores;temp];
                 
                 cores=sortrows(cores);
            elseif(MooreWhich==2)
                %Frequency
                fprintf('\nPlease input the years as a vector (i.e. [2017;2018;2019]): ');
                frequency2=input('');
                
                frequency3=input('Please input the corresponding values as a vector (i.e. [9;10;11]): ');
                temp=[frequency2,frequency3];
                frequency=[frequency;temp];
                
                frequency=sortrows(frequency);
            elseif(MooreWhich==3)
                %Transistors
                fprintf('Please input the years as a vector (i.e. [2017;2018;2019]): ');
                transistors2=input('');
                
                transistors3=input('Please input the corresponding values as a vector (i.e. [9;10;11]): ');
                temp=[transistors2,transistors3];
                transistors=[transistors;temp];
                
                transistors=sortrows(transistors);
            elseif(MooreWhich==4)
                %SpecINT
                fprintf('Please input the years as a vector (i.e. [2017;2018;2019]): ');
                specint2=input('');
          
                specint3=input('Please input the corresponding values as a vector (i.e. [9;10;11]): ');
                temp=[specint2,specint3];
                specint=[specint;specint3];
                
                specint=sortrows(specint);
                
            else
                %Watts
                fprintf('Please input the years as a vector (i.e. [2017;2018;2019]): ');
                watts2=input('');
                
                watts3=input('Please input the corresponding values as a vector (i.e. [9;10;11]): ');
                temp=[watts2,watts3];
                watts=[watts;temp];
                
                watts=sortrows(watts);
            end
            
        else
            warning('User did not choose an option. Program will proceed to Part 2');
            break;
        end
        userAgain2=menu('Do you like to re-run Part 1?','Yes','No');
        if(userAgain2==0)
            warning('Assuming User does not want to retry. Program will proceed to Part 2');
            break;
        elseif(userAgain2==1)
            cond2=1;
        else
            cond2=0;
        end
    end
end

cond=1;                                                                 %To allow initial run of while loop
errorCount=1;
while(cond==1)
        %Ask User for Local Based or Server Based
        based=input('\nDo you want to run VR locally or on a server? Type L for local or S for server: ','s');
        
        if(strcmpi(based,'L'))              %If User choose Local based
            
            budget=input('Do you want to use minimum required hardware or use your own build? Type M for minimum or O for own build: ','s');
            %Conditional Case Switch Bettween Min Hardware vs Own Build
            if(strcmpi(budget,'O'))
                cpu=input('Do you have an Intel Core i5 or faster CPU? Y/N: ','s');
                ram=input('Do you have at least 8GB of RAM? Y/N: ','s');
                gpu=input('Do you have Geforce GTX 1070 (equivalent or better) Y/N: ','s');
                
                %Conditional Check
                if(strcmpi(cpu,'Y') && strcmpi(ram,'Y') && strcmpi(gpu,'Y'))  
                    userBuildCost=input('Please enter the value of your current build: ');
                    %Break Even Time
                    totalSumServer=sum(cost(:,3));
                    months=(userBuildCost-totalSumServer)/(internetSpeedCost+CloudCost);
                    fprintf('The total time it will take for your build to break even with Cloud Based Gaming is: %0.2f months ',months);
                else
                    disp('Please check your hardware and update accordingly to Nvidia''s mininum requirements');
                end             
            else
                fprintf('\nThe minimum hardware requirement build is listed below:');                
                for(i=[2:r])
                    fprintf('\n%s\t\t%s\t\t$%0.2f',name{i,1},name{i,2},cost(i-1,1));
                end
                fprintf('\n\n');
                warning('Please check if the current prices are correct or if you want to change parts!');
                change=input('Do you want to change any parts or values for mininum build? Y/N: ','s');               
                if(strcmpi(change,'Y'))
                    for(A=[2:9])
                        fprintf('Please input the new product name for %s: ', name{A,1});
                        name{A,2}=input('','s');
                    end
                    cost(:,1)=input('\nPlease input new values for ALL components in the correct order [CPU; Motherboard; Memory; Storage; Video Card; Case; Power Supply,OS]: ');
                    cond3=1;
                    while(cond3==1)
                        if(length(cost(:,1))~=8 && any(cost(:,1)<0))
                            cost(:,1)=input('\nPlease input new values for ALL components in the correct order [CPU; Motherboard; Memory; Storage; Video Card; Case; Power Supply,OS]');
                        else
                            for(i=[2:r])
                                fprintf('\n%s\t\t%s\t\t$%0.2f',name{i,1},name{i,2},cost(i-1,1));
                            end
                            break;
                        end
                    end
                end
                %Break Even Time
                totalSumServer=sum(cost(:,3));
                totalSumLocal=sum(cost(:,1));
                months=(totalSumLocal-totalSumServer)/(internetSpeedCost+CloudCost);
                fprintf('\nThe total time it will take for your build to break even with Cloud Based Gaming is: %0.2f months ',months);
            end    
        else
            %If user chooses Server Based
            internetSpeedCost=mean(InternetCost(:))*25;
            fprintf('\n');
            warning('Assuming Average Internet Cost for 25Mbps is approximately %0.0f/mo. Is this fine? Y/N ',internetSpeedCost);
            internetYN=input('Y/N: ','s');
            %Internet Speed Cost/Data Validation
            if(strcmpi(internetYN,'N'))
                internetSpeedCost=input('\nPlease enter your monthly internet speed at 25Mbps: ');
                cond4=1;
                while(cond4==1)
                    if(internetSpeedCost<=0)
                        internetSpeedCost=input('\nPlease enter your monthly internet speed at 25Mbps: ');
                    else
                        break;
                    end
                end
            end
            CloudCost=12;
            fprintf('\n')
            warning('Prices are according to Nvidia''s Geforce Now Program. Actual program currently does not exist');
            warning('Assuming Server Based Computing Cost is %i/mo. Is this fine? Y/N',CloudCost);
            cloudYN=input('Y/N: ','s');
            if(strcmpi(cloudYN,'N'))
                CloudCost=input('Please enter your monthly Server Based Computing Cost: ');
                cond5=1;
                while(cond5==1)
                    if(CloudCost<=0)
                        CloudCost=input('\nPlease enter your monthly internet speed at 25Mbps: ');
                    else
                        break;
                    end
                end
            end
            %Break Even Time
            totalSumServer=sum(cost(:,3));
            totalSumLocal=sum(cost(:,1));
            months=(totalSumLocal-totalSumServer)/(internetSpeedCost+CloudCost);
            fprintf('\nThe total time it will take for your build to break even with Local Based Gaming is: %0.2f months ',months);
        end
        %Re-run of Part 2
        userAgain=input('\n\nDo you want to re-run Part 2? Y/N: ','s');
        if(strcmpi(userAgain,'Y'))
            cond=1;
        else
            cond=0;
        end
end
