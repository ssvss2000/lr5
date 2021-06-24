require 'socket'

server = TCPServer.new 6389

class CashMachine
  
  $cash = (File.exists?('D:\balance.txt') ? File.read('D:\balance.txt') : 100.0).to_f
  
  def deposit(sum)
    if sum > 0
    $cash = sum + $cash
    	else 'Your amount must be greater than zero!'		
    end	
    "Your balance1: #{$cash}"
  end

  def withdraw(sum)
    if sum > 0 && sum <= $cash
    $cash = $cash - sum
    	else 'Your amount is not correct!'
    end	
    "Your balance2: #{$cash}"
  end

  def balance
    "Your balance: #{$cash}"
  end  
end

while (connection = server.accept)
  cmachine = CashMachine.new

  puts('Сервер запущен')
  request = connection.gets
  pathway, full_path = request.split(' ')
  path = full_path.split('/')[1]
 
  if full_path.split('/')[1].include?('?')
    method = path.split('?')[0]
    value = path.split('?')[1].split('=')[1].to_f
  end

  connection.print "HTTP/1.1 200\r\n"
  connection.print "Content-Type: text/html\r\n"
  connection.print "\r\n"
  
  next if value.nil?
  connection.print case method
                   when 'deposit'
                     cmachine.deposit(value)
                   when 'withdraw'
                     cmachine.withdraw(value)
                   when 'balance'
                     cmachine.balance
                   else
                     'Oops error...'
                   end
  File.open('D:\balance.txt', "w") { |f| f.write "#{$cash}" }  
  connection.close 
end
