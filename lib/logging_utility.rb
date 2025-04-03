module LoggingUtility
  
    def log_star(message)
      border = "*" * (message.length + 4)
      puts border
      puts "* \e[33m#{message}\e[0m *" # yellow text
      puts border
    end
  
  end