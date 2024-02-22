global looprun
looprun=[24,44,64,88,108,128,152,172,192 216,236,256,280,300,320,344,364,384,408,428,448,472,492,512,536,556,576,600,620,640,664,684,704,728];
global str
global strndecrypt
global stroriginal
global arr
global g
global strmain2
strmain2='';
global b
 b='';
arr=[];
global a
a = [0,2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59];

% main
retrieve();
disp(['Hidded encrypted text: ',strmain2]);
decryptedValue = decryptAES(strmain2);
fprintf('After 1st decryption : %s\n',decryptedValue);
divided(decryptedValue);
decrypt();
disp(['After 2nd decryption (original text): ',strndecrypt]);

function retrieve()

    global strmain2 b g looprun

A = imread('stego.png');
Red = A(:,:,1); 
Green = A(:, :, 2);
Blue= A(:, :, 3);
[rows, cols] = size(Red);

            decimalRedMatrix = Red;
            decimalGreenMatrix = Green;
            decimalBlueMatrix = Blue;
            

                RedString = dec2bin(decimalRedMatrix(1, cols),8);
                GreenString = dec2bin(decimalGreenMatrix(1, cols),8);
                BlueString = dec2bin(decimalBlueMatrix(1, cols),8);
        ans='' ;
        cnt=1;
        for i=1:1:3
                    if(cnt<=3)
                             for m=8:-1:6
                                ans=strcat(ans,RedString(m));
                                cnt=cnt+1;
                             end
                        
                          else if(cnt>=4 && cnt<=6)
                              for m=8:-1:6
                                 ans=strcat(ans,GreenString(m));
                                 cnt=cnt+1;
                              end
                          
                           else 
                               for m=8:-1:6
                                    ans=strcat(ans,BlueString(m));
                                    cnt=cnt+1;
                               end
                          end
                    end
        end  
            
 strmain='';
 g=bin2dec(ans);
 r=1;
 x=floor(g/16);

 for i = 1:1:looprun(x+1)

                binaryRedString = dec2bin(decimalRedMatrix(i, i),8);
                binaryGreenString = dec2bin(decimalGreenMatrix(i, i),8);
                binaryBlueString = dec2bin(decimalBlueMatrix(i, i),8);

               cnt=1;

               while(cnt<=8)

                          if(cnt<=3)
                             for m=8:-1:6
                                strmain=strcat(strmain,binaryRedString(m));
                                cnt=cnt+1;
                             end

                          else if(cnt>=4 && cnt<=6)
                              for m=8:-1:6
                                strmain=strcat(strmain,binaryGreenString(m));
                                 cnt=cnt+1;
                              end

                           else 
                               for m=8:-1:7
                                   strmain=strcat(strmain,binaryBlueString(m));
                                    cnt=cnt+1;
                                    if (m==7 && r<=g)
                                        b=strcat(b,binaryBlueString(m-1));
                                        r=r+1;
                                    end      
                                end


                              end
                          end
               end
 end   

S = strmain;
str='';
k=1;
m=length(S)/8;
for i=1:1:m
cnt=1;
while(cnt<=8 && k<=length(S))

        str=strcat(str,S(k));
        k=k+1;
        cnt=cnt+1;
end
    binmtx = bin2dec(str);   
    chrmtx = char(binmtx);
    strmain2=strcat(strmain2,chrmtx);
    str='';
end

end


function divided(strk)
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
