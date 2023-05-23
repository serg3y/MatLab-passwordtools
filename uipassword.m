function pass = uipassword(str,lbl)
%Create password dialogue (hide password input).
% pass = uipassword       -display dialogue
% pass = uipassword(str)    -allowed pass characters (default:[32:126])
% pass = uipassword(str,lbl)  -dialogue heading (default:'Enter Password')
%
%Remarks:
%-WindowStyle='modal' blocks user interaction with other UI elements.
%-If Esc is pressed empty char is returned.
%
%Example:
% pass = uipassword('0123456789','Enter PIN')
%
%See also: uilogin, strencrypt

%defaults
if nargin<1 || isempty(str), str = 32:126; end %allowed pass characters
if nargin<2 || isempty(lbl), lbl = 'Enter password'; end %dialogue heading

%checks
if ~usejava('awt') %matlab was started with -nojvm flag (ie no java) 
    disp(lbl)
    pass = input('Password:','s'); %revert to simple command line queries
    return
end

%main
ScreenSize = get(0,'ScreenSize');
hFig  = figure(WindowStyle='modal' ,Units='pixels',Position=[(ScreenSize(3:4)-[300 75])/2 300 75],Name=lbl,Resize='off',NumberTitle='off',Menubar='none',Color=[0.9 0.9 0.9],KeyPressFcn=@KeyPress,CloseRequestFcn=@(~,~)uiresume);
hPass = uicontrol(hFig,Style='text',Units='pixels',Position=[20 30 260 20],FontSize=10,BackGroundColor='w');
pass = ''; %init
uiwait %hold program execution
delete(hFig) %clean up

    function KeyPress(~,event)
        if event.Key=="backspace"
            pass = pass(1:end-1); %shorten password
        elseif event.Key=="return"
            uiresume, return %done
        elseif event.Key=="escape"
            pass = '';
            uiresume, return %abort
        elseif contains(event.Character,num2cell(char(str)))
            pass(end+1) = event.Character; %append key to password
        end
        hPass.String = repmat(char(8226),size(pass)); %display dots instead of password
    end
end