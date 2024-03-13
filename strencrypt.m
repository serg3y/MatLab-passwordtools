function [txt, key] = strencrypt(txt, key, valid)
% Encrypt or decrypt a string (uses a key and MATLAB number generator).
%
% txt = strencrypt(text, key)     - Encrypt a string using a custom key
% txt = strencrypt(code, -key)     - Decrypt a string
% [code, key] = strencrypt(text)    - Encrypt using a random key
%
% Remarks:
% - Can be used to store a password or text a *bit* more safely.
% - The same MATLAB number generator needs to be used to encrypt and decrypt.
%
% Example:
% code = strencrypt('MySecret', pi)  % Returns '#^o7Yiq)'
% text = strencrypt(code, -pi)       % Returns 'MySecret'
%
% See also: uilogin, uipassword

% Defaults
if nargin < 2 || isempty(key)
    key = randi(999999); % Make a random key
end
if nargin < 3 || isempty(valid)
    valid = char(32:126);
end

% Initialization
if ~all(ismember(txt, valid), 'all')
    error('Encountered invalid characters: "%s"', setdiff(txt, valid)); % Check
end
n = numel(valid);            % Number of allowed characters
txt2num(valid) = 1:n;        % Lookup to convert ASCII to numbers
num2txt(1:n) = valid;        % Lookup to convert numbers to ASCII
s = rng(abs(key), 'twister');% Use key as seed to generate numbers
rnd = randi(n, size(txt));   % Generate positive random integers, 1 to n
rng(s);                      % Return number generator to previous state

% Main
num = txt2num(txt);          % Convert text to numbers
rnd = sign(key) * rnd;       % Sign indicates encryption vs decryption
num = mod(num + rnd - 1, n) + 1; % Apply offsets and wrap values (use base 1)
txt = num2txt(num);          % Convert back to text
