3/27/21 50 min sections 34-41

Flow of the app:
String -> Compute MD5 hash of string -> List of numbers based on the string -> Pick color -> Build grid of squares -> Convert grid into image -> Save image

iex(1)> hash = :crypto.hash(:md5, "banana") 
<<114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65>>
iex(2)> Base.encode16(hash)
"72B302BF297A228A75730123EFEF7C41"
iex(3)> :binary.bin_to_list(hash)
[114, 179, 2, 191, 41, 122, 34, 138, 117, 115, 1, 35, 239, 239, 124, 65]

How we built the list of numbers in terminal is the same as using the pipe operator in the hash_input function. The key points here are to know that we are returning a list of numbers that we can use to generate the image. The numbers in the list will range from 0-255. So we can use the first 3 values to form RGB. The first 15 values will be assigned to the grid with the last two columns being mirrors of the first two, and odd numbers will be left white, and even will be filled in with the color.

Struct: a map used to store data in an Elixir application, can be assigned default values, and have advantages on compiling.
Reminder you can't attach functions to the struct like you might in Ruby. We could use a map, but by convention if we know what data it is going to hold, we'll use a struct.

  def pick_color(image) do 
    %Identicon.Image{hex: hex_list} = image
    [r, g, b | _tail] = hex_list
    [r, g, b]
  end

  Pattern matching here, we need to add the | _tail to indicate an arbitrarily long rest of the list

  We can refactor it as:
  def pick_color(image) do 
    %Identicon.Image{hex: [r, g, b | _tail]} = image
    [r, g, b]
  end

  Then refactor it so that it's returning the struct with a color key