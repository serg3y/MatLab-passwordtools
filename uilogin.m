function [user,pass] = uilogin(str,lbl,user)
%Create username and password dialogue (hide password input).
% [user,pass] = uilogin       -display dialogue
% [user,pass] = uilogin(str)     -allowed pass characters (default:[32:126])
% [user,pass] = uilogin(str,lbl)    -dialogue heading (default:'Login')
% [user,pass] = uilogin(str,lbl,user)  -prefill username (default: '')
%
%Remarks:
%-WindowStyle='modal' blocks user interaction with other UI elements.
%-If Esc is pressed empty char is returned.
%
%Example:
% [user,pass] = uilogin([],'My Program Login')
%
%See also: uipassword, strencrypt

%default
if nargin<1 || isempty(str), str  = 32:126;  end %allowed pass characters
if nargin<2 || isempty(lbl), lbl  = 'Login'; end %dialogue heading
if nargin<3 || isempty(user),user = '';      end %prefill username

%checks
if ~usejava('awt') %matlab was started with -nojvm flag (ie no java) 
    disp(lbl)
    user = input('Username:','s'); %revert to simple command line queries
    pass = input('Password:','s');
    return
end

%main
sz = get(0,'ScreenSize');
hFig  = figure(WindowStyle='modal' ,Position=[(sz(3:4)-[350 100])/2 350 100],Name=lbl,Resize='off',NumberTitle='off',Menubar='none',Color=[0.9 0.9 0.9],CloseRequestFcn=@(~,~)uiresume);
hUser = uicontrol(hFig,Style='edit',Position=[80 60 250 20],KeyPressFcn=@userKeyPress,FontSize=10,BackGroundColor='w',String=user);
hPass = uicontrol(hFig,Style='text',Position=[80 30 250 20],ButtonDownFcn=@passClick,FontSize=10,BackGroundColor='w',Enable='Inactive');
hDumy = uicontrol(hFig,Style='push',Position=[ 0  0   0  0],KeyPressFcn=@passKeyPress); %button represents password text box, to simulate tab behaviour
annotation(hFig,'textbox',Units='pixels',Position=[00 60 80 20],String='Username',EdgeColor='n',VerticalAlignment='middle',HorizontalAlignment='right')
annotation(hFig,'textbox',Units='pixels',Position=[00 30 80 20],String='Password',EdgeColor='n',VerticalAlignment='middle',HorizontalAlignment='right')
pass = ''; %init password
uicontrol(hUser) %give focuse to username
uiwait %wait for uiresume command
drawnow %required for next line
user = hUser.String;
delete(hFig) %clean up

    function passClick(~,~)
        uicontrol(hDumy)
    end
    function userKeyPress(~,event)
        if event.Key=="return"
            uiresume, return %done
        elseif event.Key=="escape"
            hUser.String = ''; pass = '';
            uiresume, return %abort
        end
    end
    function passKeyPress(~,event)
        if event.Key=="backspace"
            pass = pass(1:end-1); %shorten password
        elseif event.Key=="return"
            uiresume, return %done
        elseif event.Key=="escape"
            hUser.String = ''; pass = '';
            uiresume, return %abort
        elseif contains(event.Character,num2cell(char(str)))
            pass(end+1) = event.Character; %append key to password
        end
        hPass.String = repmat(char(8226),size(pass)); %display dots instead of password
    end
end