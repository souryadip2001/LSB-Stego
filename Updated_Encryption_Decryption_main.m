global str
global stroriginal
global strencrypt
global strndecrypt
global arr
arr=[];
global a
a = [0,2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151];
global b
b = '';

% Main code
strk = input('Enter a string: ', 's');
divide(strk);
encrypt();
disp(['1st layer Encryption: ',strencrypt]);
encryptedValue = encryptAES(strencrypt);
fprintf('2nd layer Encryption: %s',encryptedValue);
decryptedValue = decryptAES(encryptedValue);
fprintf('\n2nd layer Decryption: %s\n',decryptedValue);
divide(decryptedValue);
decrypt();
disp(['1st layer Decryption:',strndecrypt]);

% divide function
function divide(strk)
    global stroriginal arr str;
    str3 = '';
    str1 = '';
    arr = [];
    stroriginal=[];
    str=[];

    for i = 1:length(strk)
        if strk(i) == ' '
            stroriginal=[stroriginal, {str3}];
            str3 = '';
        else
            str3 = [str3, strk(i)];
        end
    end
    stroriginal=[stroriginal, {str3}];  
 
    for i = 1:length(stroriginal)
         p = length(stroriginal{i});
         arr(i)= p;
         if(p > 8)
             cnt = 0;
             for j = 1:p
                 if cnt == 8
                     str =[str,{str1}];
                     cnt = 0;
                     str1 = '';
                 end
     
                 str1 = [str1,stroriginal{i}(j)];
                 cnt = cnt + 1;
             end
     
             if ~isempty(str1)
                 str =[str,{str1}];
                 str1 = '';
             end
        
         else
             str =[str,{stroriginal{i}}];
         end
    
    end
    stroriginal = [];
end

% encrypt function
function encrypt()
    global str stroriginal b a arr strencrypt
    strencrypt2='';
    strg = '';
    str2='';
    x = 0;
    r=1;
    for k = 1:length(str)
        str2='';

        n = length(str{k});
        for i = 1:n
           if (double(str{k}(i)) - a(n + i)) < 33 && (double(str{k}(i)) + a(n + i)) > 126
                str2 = [str2, char(double(str{k}(i)) + (2 * i + 1))];

           elseif (double(str{k}(i)) + a(n + i)) > 126
                str2 = [str2, char(double(str{k}(i)) - a(n + i))];
                b=[b,'1'];

            else
                str2 = [str2, char(double(str{k}(i)) + a(n + i))];
                b=[b,'0'];
            end
        end

        stroriginal=[stroriginal, {str2}];
    end
    % disp(stroriginal);
    strencrypt='';
    for i = 1:length(arr)
        x = arr(i);
        % disp(x);
        if x == length(stroriginal{r})
            strencrypt2 = [strencrypt2, stroriginal{r},' '];
            r = r + 1;
        else
            while (x ~= 0)
                strg = [strg, stroriginal{r}];
                x = x - length(stroriginal{r});
                r = r + 1;
            end
            strencrypt2 = [strencrypt2,strg,' '];
            strg = '';
        end
    end

    strencrypt2(end) = [];
    stroriginal = [];
    strencrypt=strencrypt2;
    strencrypt2='';
end

% decrypt function
function decrypt()
    global str stroriginal arr strndecrypt b a;
    strndecrypt2='';
    str3 = '';
    strget = '';
    r = 1;
    x = 0;
    u = 1;
    for k = 1:length(str)
        str3 = '';
        n = length(str{k});

        for i = 1:n
            if (double(str{k}(i) - (2 * i + 1) - a(n + i)) < 33) && (double(str{k}(i) - (2 * i + 1) + a(n + i)) > 126)
                str3 = [str3, char(double(str{k}(i) - (2 * i + 1)))];
            end

            if (b(u) == '1')
                str3 = [str3, char(double(str{k}(i) + a(n + i)))];
                u=u+1;
            else
                str3 = [str3, char(double(str{k}(i) - a(n + i)))];
                u=u+1;
            end
        end

        stroriginal =[stroriginal, {str3}];
    end

    for i = 1:length(arr)
        x = arr(i);

        if x == length(stroriginal{r})
            strndecrypt2 = [strndecrypt2,stroriginal{r},' '];
            r = r + 1;
        else
            while (x ~= 0)
                strget = [strget,stroriginal{r}];
                x = x - length(stroriginal{r});
                r = r + 1;
            end

            strndecrypt2 = [strndecrypt2, strget, ' '];
            strget = '';
        end
    end

    strndecrypt2(end) = [];
    stroriginal =[];
    strndecrypt=strndecrypt2;
    strndecrypt2='';

end
function encryptedValue = encryptAES(strToEncrypt)
    secretKey = '0123456789abcdefg';
    saltValue = 'acharchowjoarbane';
    iv = zeros(1, 16, 'uint8');
    javaPlaintext = java.lang.String(strToEncrypt);
    javaSecretKey = java.lang.String(secretKey);
    javaSalt = java.lang.String(saltValue);
    spec = javax.crypto.spec.PBEKeySpec(javaSecretKey.toCharArray(), javaSalt.getBytes(), 65536, 256);
    factory = javax.crypto.SecretKeyFactory.getInstance('PBKDF2WithHmacSHA256');
    tmp = factory.generateSecret(spec);
    javaSecretKeySpec = javax.crypto.spec.SecretKeySpec(tmp.getEncoded(), 'AES');
    cipher = javax.crypto.Cipher.getInstance('AES/CBC/PKCS5Padding');
    cipher.init(javax.crypto.Cipher.ENCRYPT_MODE, javaSecretKeySpec, javax.crypto.spec.IvParameterSpec(iv));
    encryptedBytes = cipher.doFinal(javaPlaintext.getBytes(java.nio.charset.StandardCharsets.UTF_8));
    encryptedValue = char(java.util.Base64.getEncoder.encode(encryptedBytes));
end

function decryptedValue = decryptAES(strToDecrypt)
    secretKey = '0123456789abcdefg';
    saltValue = 'acharchowjoarbane';
    iv = zeros(1, 16, 'uint8');
    javaSecretKey = java.lang.String(secretKey);
    javaSalt = java.lang.String(saltValue);
    spec = javax.crypto.spec.PBEKeySpec(javaSecretKey.toCharArray(), javaSalt.getBytes(), 65536, 256);
    factory = javax.crypto.SecretKeyFactory.getInstance('PBKDF2WithHmacSHA256');
    tmp = factory.generateSecret(spec);
    javaSecretKeySpec = javax.crypto.spec.SecretKeySpec(tmp.getEncoded(), 'AES');
    cipher = javax.crypto.Cipher.getInstance('AES/CBC/PKCS5PADDING');
    cipher.init(javax.crypto.Cipher.DECRYPT_MODE, javaSecretKeySpec, javax.crypto.spec.IvParameterSpec(iv));
    decryptedBytes = cipher.doFinal(java.util.Base64.getDecoder.decode(strToDecrypt));
    decryptedValue = native2unicode(decryptedBytes,'UTF-8');
end



