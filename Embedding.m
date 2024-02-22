global str
global stroriginal
global strencrypt
global encryptedValue
global arr
arr=[];
global a
a = [0,2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151];
global b
b = '';

% Main code
A = imread('leenastego.png');
% imshow(A);
Red = A(:,:,1);
Green = A(:, :, 2);
Blue= A(:, :, 3);
[rows, cols] = size(Red);
strk = input('Enter a string: ', 's');
divide(strk);
encrypt();
encryptAES(strencrypt);


if((max(rows,cols))<length(encryptedValue))
    disp('Not possible to hide the text into the picture');

else

    u=dec2bin(length(strk),9);
    stego(encryptedValue,Red,Green,Blue,u);    

end

function stego(encryptedValue,Red,Green,Blue,u)     

global strencrypt b
[rows, cols] = size(Red);
        str2='';
        k=1;
        r=1;
        
            % disp(['1st layer Encryption: ',strencrypt]);
            % fprintf('2nd layer Encryption: %s\n',encryptedValue);

        for i=1:length(encryptedValue)
              str2=strcat(str2,dec2bin(double(encryptedValue(i)),8));   
        end
        % 
        % disp(['Encryptedval in binary:' str2]);

            decimalRedMatrix = Red;
            decimalGreenMatrix = Green;
            decimalBlueMatrix = Blue;
   
            binaryRedMatrix = zeros(rows, cols);
            binaryGreenMatrix = zeros(rows, cols);
            binaryBlueMatrix = zeros(rows, cols);
    
     for i = 1:1:rows
            
                binaryRedString = dec2bin(decimalRedMatrix(i, i),8);
                binaryGreenString = dec2bin(decimalGreenMatrix(i, i),8);
                binaryBlueString = dec2bin(decimalBlueMatrix(i, i),8);

               cnt=1;
                     
                 while(cnt<=8 && k<=length(str2))
                        
                          if(cnt<=3)
                             for m=8:-1:6
                                binaryRedString(m)=str2(k);
                                k=k+1;
                                cnt=cnt+1;
                             end
                        
                          else if(cnt>=4 && cnt<=6)
                              for m=8:-1:6
                                 binaryGreenString(m)=str2(k);
                                 k=k+1;
                                 cnt=cnt+1;
                              end
                          
                           else 
                               for m=8:-1:7
                                    binaryBlueString(m)=str2(k);
                                    cnt=cnt+1;
                                    k=k+1;
                                    if (m==7 && r<=length(b))
                                        binaryBlueString(m-1)=b(r);
                                        r=r+1;
                                    end      
                                end
                         
                    
                              end
                        end
                 end
      
                     binaryRedArray = bin2dec(binaryRedString);
                     binaryRedMatrix(i, i) = binaryRedArray;

                     binaryGreenArray = bin2dec(binaryGreenString);
                     binaryGreenMatrix(i, i) = binaryGreenArray;

                     binaryBlueArray = bin2dec(binaryBlueString);
                     binaryBlueMatrix(i, i) = binaryBlueArray;

    end


                for i=1:1:rows
                    for j=1:1:cols

                        if(i~=j)
                            binaryRedMatrix(i, j)=decimalRedMatrix(i, j);
                            binaryGreenMatrix(i, j)=decimalGreenMatrix(i, j);
                           binaryBlueMatrix(i, j)=decimalBlueMatrix(i, j);
                         end
                     end
                end

                RedString = dec2bin(decimalRedMatrix(1, cols),8);
                GreenString = dec2bin(decimalGreenMatrix(1, cols),8);
                BlueString = dec2bin(decimalBlueMatrix(1, cols),8);
            
                cnt=1;
                k=1;
                for i=1:1:3
                    if(cnt<=3)
                             for m=8:-1:6
                                RedString(m)=u(k);
                                k=k+1;
                                cnt=cnt+1;
                             end
                        
                          else if(cnt>=4 && cnt<=6)
                              for m=8:-1:6
                                 GreenString(m)=u(k);
                                 k=k+1;
                                 cnt=cnt+1;
                              end
                          
                           else 
                               for m=8:-1:6
                                    BlueString(m)=u(k);
                                    cnt=cnt+1;
                                    k=k+1;     
                               end
                          end
                    end
                end

                     RedArray = bin2dec(RedString);
                     binaryRedMatrix(1, cols) = RedArray;

                     GreenArray = bin2dec(GreenString);
                     binaryGreenMatrix(1, cols) = GreenArray;

                     BlueArray = bin2dec(BlueString);
                     binaryBlueMatrix(1, cols) = BlueArray;


            i2(:,:,1)=binaryRedMatrix;
            i2(:,:,2)=binaryGreenMatrix;
            i2(:,:,3)=binaryBlueMatrix;
           
            imwrite(uint8(i2),'stego.png');
            disp("..Stego-image successfully created..");
end

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

function encryptAES(strToEncrypt)

    global encryptedValue

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