3/27/21

Flow of the app:
String -> Compute MD5 hash of string -> List of numbers based on the string -> Pick color -> Build grid of squares -> Convert grid into image -> Save image

iex(1)> hash = :crypto.hash(:md5, "banana") 
<<114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65>>
iex(2)> Base.encode16(hash)
"72B302BF297A228A75730123EFEF7C41"
iex(3)> :binary.bin_to_list(hash)
[114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]

How we built the list of numbers in terminal is the same as using the pipe operator in the hash_input function. The key points here are to know that we are returning a list of numbers that we can use to generate the image. The numbers in the list will range from 0-255. So we can use the first 3 values to form RGB. The first 15 values will be assigned to the grid with the last two columns being mirrors of the first two, and odd numbers will be left white, and even will be filled in with the color.