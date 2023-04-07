function pass = getpass(str,lbl)
%Create a dialogue for user to enter password while hiding the input.
% pass = getpass       -display dialogue
% pass = getpass(str)    -list of valid characters (default: char(32:126))
% pass = getpass(str,lbl)  -dialogue heading (default: 'Enter Password')
%
%Remarks:
%-WindowStyle='modal' blocks user interaction with other UI elements.

if nargin<1 || isempty(str), str = char(32:126); end %default charset
if nargin<2 || isempty(lbl), lbl = 'Enter Password'; end %default heeding

ScreenSize = get(0,'ScreenSize');
hfig  = figure(WindowStyle='modal' ,Units='pixels',Position=[(ScreenSize(3:4)-[300 75])/2 300 75],Name=lbl,Resize='off',NumberTitle='off',Menubar='none',KeyPressFcn=@keypress,CloseRequestFcn=@(~,~)uiresume);
hpass = uicontrol(hfig,Style='text',Units='pixels',Position=[20 30 260 20],FontSize=10,BackGroundColor='w');
hwarn = uicontrol(hfig,Style='text',Units='pixels',Position=[50  2 200 20],FontSize=10);
pass = ''; %init
uiwait %hold program execution
delete(hfig) %clean up

    function keypress(~,event)
        switch event.Key
            case 'backspace'
                pass = pass(1:end-1); %shorten password
            case {'return' 'escape'} %Enter or ESC was pressed
                uiresume, return %exit
            case num2cell(char(str))
                pass(end+1) = event.Key; %append key to password
            otherwise
                hwarn.String='forbidden character'; %warn user
                pause(0.5);
                hwarn.String=''; 
        end
        hpass.String = repmat(char(8226),size(pass)); %display dots instead of password
    end
end