require_relative 'game'

loop do
  puts "\n\nGame of Life\n\n"
  puts "Tip - Press ESC to exit the game once you start it.\n\n"
  print "(Enter 's' to Start, 'q' to QUIT) "

  input = ''

  loop do
    input = gets.chomp[0].downcase
    break if %w(q s).include?(input)
  end

  if input == 's'
    Window.new(40, 40).run
  end

  break if input == 'q'
end
