def caeser_cipher(text, offset)
    cipher_text = text.gsub(/([a-zA-Z])/) do |letter|
        base = 97 # 'a' ASCII value
        if letter===letter.capitalize
            base = 65
        end

        (((letter.ord + offset - base+26)%26)+base).chr("UTF-8")
    end

    return cipher_text
end

if __FILE__ == $0
  puts 'Give me the text, please...'
  text = gets
  puts 'Give me the offset, please...'
  offset = gets.chomp.to_i

  puts caeser_cipher(text, offset)
end