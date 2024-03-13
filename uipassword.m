function pass = uipassword(str, lbl, block)
% Create password dialogue (hide password input).
%
% pass = uipassword         - Display dialogue
% pass = uipassword(str)       - Allowed pass characters (default: [32:126])
% pass = uipassword(str, lbl)     - Dialogue heading (default: 'Enter password')
% pass = uipassword(str, lbl, block) - If true, blocks user interaction
%                                      with other windows (default: 0)
%
% Remarks:
% - WindowStyle='modal' blocks user interaction with other UI elements.
% - If Esc is pressed, an empty char is returned.
%
% Example:
% pass = uipassword('0123456789', 'Enter PIN')
%
% See also: uilogin, strencrypt

% Defaults
if nargin < 1 || isempty(str)
    str = 32:126; % Allowed pass characters
end
if nargin < 2 || isempty(lbl)
    lbl = 'Enter password'; % Dialogue heading
end
if nargin >= 3 && isscalar(block) && block
    WinStyle = 'modal'; % Blocks user interaction with other windows
else
    WinStyle = 'normal';
end

% Checks
if ~usejava('awt') % MATLAB was started with -nojvm flag (i.e., no java)
    disp(lbl)
    pass = input('Password: ', 's'); % Revert to simple command line queries
    return
end

% Close any old dialogues
delete(findobj(0, 'Tag', 'uipassword'))

% Main
screenWH = get(0).ScreenSize(3:4);
hFig = figure('WindowStyle', WinStyle, 'Units', 'pixels', 'Position', [(screenWH - [300 75]) / 2, 300, 75], 'Name', lbl, 'Resize', 'off', 'NumberTitle', 'off', 'Menubar', 'none', 'Color', [0.9 0.9 0.9], 'KeyPressFcn', @KeyPress, 'CloseRequestFcn', @(~,~)uiresume, 'Tag', 'uipassword');
[~] = uicontrol(hFig, 'Style', 'push', 'Position', [16 26 268 28], 'Enable', 'off'); % Add a border
hPass = uicontrol(hFig, 'Style', 'text', 'Units', 'pixels', 'Position', [20 30 260 20], 'FontSize', 10, 'BackGroundColor', 'w');
pass = ''; % Init
uiwait % Hold program execution
delete(hFig) % Clean up

% Callbacks
function KeyPress(~, event)
    if isequal(event.Modifier, {'control'}) && isequal(event.Key, 'v') % Paste from clipboard
        pass = clipboard('paste');
    elseif event.Key == "backspace"
        pass = pass(1:end-1); % Shorten password
    elseif event.Key == "return" % Done
        uiresume
        return
    elseif event.Key == "escape" % Abort
        pass = '';
        uiresume
        return
    elseif contains(event.Character, num2cell(char(str))) % Append key to password
        pass(end+1) = event.Character;
    end
    hPass.String = repmat(char(8226), size(pass)); % Display dots instead of password
end

end
