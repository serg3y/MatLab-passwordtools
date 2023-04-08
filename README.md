UI and tools for requesting ans storing username and password.

See also: https://au.mathworks.com/matlabcentral/fileexchange/127469-passwordtools

Create password dialogue (hides password input).
pass = uipassword       -display dialogue
pass = uipassword(str)    -list of valid characters (default: char(32:126))
pass = uipassword(str,lbl)  -dialogue heading (default: 'Enter Password')

Create username and password dialogue (hides password input).
[user,pass] = uilogin        -display dialogue
[user,pass] = uilogin(valid)     -allowed characters (default: char(32:126))
[user,pass] = uilogin(valid,heading) -dialogue heading (default: 'Login')

Encrypt or decrypt a string (uses a key and MatLab number generator).
code = strencrypt(text,key)     -encrypt a string using a custom key
text = strencrypt(code,-key)     -decrypt a string
[code,key] = strencrypt(text)     -encrypt using a random key
