function [txt,key] = strencrypt(txt,key,valid)
%Encrypt or decrypt a string using a key and a MatLab number generator.
% code = strencrypt(text,key)
% text = strencrypt(code,-key)
% [code,key] = strencrypt(text)
%
%Remarks:
%-Can be used to store a password or text a *bit* more safely.
%-The same MatLab number generator needs to be used to encrypt and decrypt.
%
%Example:
% code = strencrypt('MySecret',pi)  %returns '#^o7Yiq)'
% text = strencrypt(code,-pi)       %returns 'MySecret'

%defaults
if nargin<2 || isempty(key), key = randi(999999); end %make a random key
if nargin<3 || isempty(valid), valid = char(32:126); end

%init
if ~all(ismember(txt,valid),'all')
    error('Encountered invalid characters: "%s"',setdiff(txt,valid)) %check
end
n = numel(valid);            %number of allowed characters
txt2num(valid) = 1:n;        %lookup to convert ASCII to numbers
num2txt(1:n) = valid;        %lookup to convert numbers to ASCII
s = rng(abs(key),'twister'); %use key as seed to generate numbers
rnd = randi(n,size(txt));    %generate positive random integers, 1 to n
rng(s);                      %return number generator to previous state

%main
num = txt2num(txt);          %convert text to numbers
rnd = sign(key)*rnd;         %sign indicates encryption vs decryption
num = mod(num+rnd-1,n)+1;    %apply offsets and wrap values (use base 1)
txt = num2txt(num);          %convert back to text