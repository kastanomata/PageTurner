module LoggingUtility
  module_function

  # Color code mappings
  COLORS = {
    reset:   "\e[0m",
    black:   "\e[30m",
    red:     "\e[31m",
    green:   "\e[32m",
    yellow:  "\e[33m",
    blue:    "\e[34m",
    magenta: "\e[35m",
    cyan:    "\e[36m",
    white:   "\e[37m",
    gray:    "\e[90m"
  }.freeze

  # Log levels with colors and symbols
  LOG_LEVELS = {
    info:    { color: :blue,    symbol: "ℹ" },
    success: { color: :green,   symbol: "✓" },
    warning: { color: :yellow,  symbol: "⚠" },
    error:   { color: :red,     symbol: "✗" },
    debug:   { color: :magenta, symbol: "⚙" },
    fatal:   { color: :red,     symbol: "💀", bg: true }
  }.freeze

  # Generic log method with full message coloring
  def log(message, level: :info, timestamp: true)
    config = LOG_LEVELS[level]
    return unless config

    timestamp_str = timestamp ? "[#{Time.now.strftime("%H:%M:%S")}] " : ""
    color_code = config[:bg] ? "\e[48;5;#{config[:color][:bg]}m" : COLORS[config[:color]]
    # symbol = "#{color_code}#{config[:symbol]}#{COLORS[:reset]}"

    colored_message = "#{color_code}#{message}#{COLORS[:reset]}"

    puts "#{timestamp_str} #{level}: #{colored_message}"
  end

  # Specific log methods with pre-configured levels
  def info(message)    = log(message, level: :info)
  def success(message) = log(message, level: :success)
  def warning(message) = log(message, level: :warning)
  def error(message)   = log(message, level: :error)
  def debug(message)   = log(message, level: :debug)
  def fatal(message)   = log(message, level: :fatal)

  # Specialized logging formats
  def divider(char = "─", color: :gray)
    puts "#{COLORS[color]}#{char * (terminal_width - 1)}#{COLORS[:reset]}"
  end

  def header(title, color: :cyan)
    divider("═", color: color)
    puts "#{COLORS[color]} #{title} #{COLORS[:reset]}"
    divider("═", color: color)
  end

  private

  def terminal_width
    `tput cols`.to_i rescue 80
  end
end
