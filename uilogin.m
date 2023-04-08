function [user,pass] = uilogin(valid,heading)
%Create username and password dialogue (hides password input).
% [user,pass] = uilogin        -display dialogue
% [user,pass] = uilogin(valid)     -allowed characters (default: char(32:126))
% [user,pass] = uilogin(valid,heading) -dialogue heading (default: 'Login')
%
%Remarks:
%-WindowStyle='modal' blocks user interaction with other UI elements.
%
%Example:
% [user,pass] = uilogin([],'My Program Login')
%
%See also: uipassword, strencrypt

if nargin<1 || isempty(valid), valid = char(32:126); end %default charset
if nargin<2 || isempty(heading), heading = 'Login'; end %default heeding

sz = get(0,'ScreenSize');
hFig  = figure(WindowStyle='modal' ,Position=[(sz(3:4)-[350 100])/2 350 100],Name=heading,Resize='off',NumberTitle='off',Menubar='none',Color=[0.9 0.9 0.9],CloseRequestFcn=@(~,~)uiresume);
hUser = uicontrol(hFig,Style='edit',Position=[80 60 250 20],KeyPressFcn=@userKeyPress,FontSize=10,BackGroundColor='w');
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
        if contains(event.Key,{'return' 'escape'})
            uiresume, return %finish
        end
    end
    function passKeyPress(~,event)
        if event.Key=="backspace"
            pass = pass(1:end-1); %shorten password
        elseif contains(event.Key,{'return' 'escape'})
            uiresume, return %done
        elseif contains(event.Character,num2cell(char(valid)))
            pass(end+1) = event.Character; %append key to password
        end
        hPass.String = repmat(char(8226),size(pass)); %display dots
    end
end