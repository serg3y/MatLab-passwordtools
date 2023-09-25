function [user,pass] = uilogin(str,lbl,user,block)
%Create username and password dialogue (hide password input).
% [user,pass] = uilogin       -display dialogue
% [user,pass] = uilogin(str)     -allowed pass characters (default:[32:126])
% [user,pass] = uilogin(str,lbl)    -dialogue heading (default:'Login')
% [user,pass] = uilogin(str,lbl,user)  -prefill username (default: '')
% [user,pass] = uilogin(str,lbl,user,block) -if true block user interaction
%                                            with other windows (default:0)
%Remarks:
%-If Esc is pressed empty char is returned.
%
%Example:
% [user,pass] = uilogin([],'My Program Login')
%
%See also: uipassword, strencrypt

% Default
if nargin<1 || isempty(str), str  = 32:126;  end %allowed password characters
if nargin<2 || isempty(lbl), lbl  = 'Login'; end %dialogue heading
if nargin<3 || isempty(user),user = '';      end %prefill username
if nargin>=4 && isscalar(block) && block
    WinStyle = 'modal'; %blocks user interaction with other windows
else
    WinStyle = 'normal';
end

% Checks
if ~usejava('awt') %matlab was started with -nojvm flag (ie no java) 
    disp(lbl)
    user = input('Username:','s'); %revert to simple command line queries
    pass = input('Password:','s');
    return
end

% Main
screenWH = get(0).ScreenSize(3:4);
hFig  = figure(WindowStyle=WinStyle,Position=[(screenWH-[350 100])/2 350 100],Name=lbl,Resize='off',NumberTitle='off',Menubar='none',Color=[0.9 0.9 0.9],CloseRequestFcn=@(~,~)uiresume);
hUser = uicontrol(hFig,Style='edit',Position=[80 60 250 20],KeyPressFcn=@userKeyPress,FontSize=10,BackGroundColor='w',String=user);
hDumy = uicontrol(hFig,Style='push',Position=[76 26 258 28],KeyPressFcn=@passKeyPress); %a button that represents the password text box, to simulate tab behaviour, also adds a border
hPass = uicontrol(hFig,Style='text',Position=[80 30 250 20],ButtonDownFcn=@passClick,FontSize=10,BackGroundColor='w',Enable='Inactive');
annotation(hFig,'textbox',Units='pixels',Position=[00 60 80 20],String='Username',EdgeColor='n',VerticalAlignment='middle',HorizontalAlignment='right')
annotation(hFig,'textbox',Units='pixels',Position=[00 30 80 20],String='Password',EdgeColor='n',VerticalAlignment='middle',HorizontalAlignment='right')
pass = ''; %init password
uicontrol(hUser) %give focuse to username
uiwait %wait for uiresume command
drawnow %required for next line
user = hUser.String;
delete(hFig) %clean up

% Callbacks
    function passClick(~,~)
        uicontrol(hDumy)
    end

    function userKeyPress(~,event) %done
        if event.Key=="return"
            uiresume
            return
        elseif event.Key=="escape" %abort
            hUser.String = '';
            pass = '';
            uiresume
            return
        end
    end

    function passKeyPress(~,event)
        if isequal(event.Modifier,{'control'}) && isequal(event.Key,'v') %paste from clipboard
            pass = clipboard('paste');
        elseif event.Key=="backspace" %shorten password
            pass = pass(1:end-1);
        elseif event.Key=="return" %done
            uiresume
            return
        elseif event.Key=="escape" %abort
            hUser.String = '';
            pass = '';
            uiresume
            return
        elseif contains(event.Character,num2cell(char(str))) %append key to password
            pass(end+1) = event.Character;
        end
        hPass.String = repmat(char(8226),size(pass)); %display dots instead of password
    end
end