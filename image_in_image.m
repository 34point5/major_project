close all
clear
clc

pkg load image

% obtain key image
picture = 'this_turns_me_on.png';
key = im2uint16(rgb2gray(imread(picture)));
m = rows(key);
n = columns(key);

% obtain message image
source = 'watermark.jpeg';
message = uint16(im2uint8(rgb2gray(imread(source))));
p = rows(message);
q = columns(message);

% generate plaintext image
plain_image = uint16(zeros(m, n));
for x = 1:p
  for y = 1:q
    plain_image(x, y) = message(x, y);
  end
end

% generate ciphertext image
cipher_image = uint16(zeros(m, n));
cipher_image = plain_image + key;

% display key image
figure
imshow(key)

% display 8-bit plaintext image
figure
imshow(uint8(plain_image))

% display ciphertext image
figure
imshow(cipher_image)

% compress ciphertext image
f = 0.001;
[U, S, V] = svd(im2double(cipher_image));
big = S(1, 1);
last = min(m, n);
for count = 1:last
  if(S(count, count) < f * big)
    S(count, count) = 0;
  endif
end
compressed_cipher = im2uint16(U * S * V');

% display compressed cipher
figure
imshow(compressed_cipher)

% decrypt and display compressed cipher
figure
imshow(uint8(compressed_cipher - key))