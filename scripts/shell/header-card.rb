#!/usr/bin/env ruby

require 'io/console'
require 'socket'

class ShellHeader
  TOP_LEFT     = "╭"
  TOP_RIGHT    = "╮"
  BOTTOM_LEFT  = "╰"
  BOTTOM_RIGHT = "╯"
  HORIZONTAL   = "─"
  VERTICAL     = "│"

  RESET  = "\e[0m"
  BOLD   = "\e[1m"
  RED    = "\e[31m"
  GREEN  = "\e[32m"
  YELLOW = "\e[33m"
  CYAN   = "\e[36m"
  GRAY   = "\e[90m"

  MAX_WIDTH = 120

  SECTIONS = {
    left: [
      { method: :welcome },
      { method: :ruby_version },
      {},
      {},
      {},
      { method: :last_login },
    ],
    right: [
      { method: :current_hostname, align: :left },
      { method: :current_ip, align: :left },
      { method: :current_directory, align: :left },
      { method: :current_git_branch, align: :left },
      { method: :current_time, align: :left },
      { method: :uptime, align: :left },
    ]
  }

  def initialize
  end

  def shell_header
    File.readlines(File.join(ENV["HOME"], ".dotfiles-header-art.txt")).each do |line|
      line = line.chomp
      line_width = line.each_char.count
      padding = [(viewport_width - line_width) / 2, 0].max
      puts (" " * padding) + line
    end
    viewport_height.times do |i|
      if i == 0
        draw_first_line
      elsif i == (viewport_height - 1)
        draw_last_line
      else
        draw_content_line_at_index(i)
      end
    end
  end

  private

  def draw_first_line
    puts TOP_LEFT + (HORIZONTAL * viewport_width) + TOP_RIGHT
  end

  def draw_last_line
    puts BOTTOM_LEFT + (HORIZONTAL * viewport_width) + BOTTOM_RIGHT
  end

  def draw_content_line_at_index(i)
    content = [:left, :right].map { |column| draw_column_line_at_index(i, column) }

    puts VERTICAL + (content.join(VERTICAL)) + VERTICAL
  end

  def draw_column_line_at_index(i, column)
    item = SECTIONS[column][i - 1]
    return " " * column_width if item.nil? || !item.key?(:method)
    pad_for_column(send(item[:method]), item[:align] || :center)
  end

  def visible_length(str)
    str.gsub(/\e\[[0-9;]*m/, "").length
  end

  def pad_for_column(content, align = :center)
    inner_width = column_width - 2
    vlen = visible_length(content)
    content = content.chars[0, inner_width].join if vlen > inner_width
    remainder = inner_width - [vlen, inner_width].min

    inner = case align
    when :left
      content + (" " * remainder)
    else
      padding_left = remainder / 2
      (" " * padding_left) + content + (" " * (remainder - padding_left))
    end

    " " + inner + " "
  end

  def viewport_height
    return @viewport_height if @viewport_height

    @viewport_height = SECTIONS.values.map { |section| section.length }.max + 2
  end

  def viewport_width
    return @viewport_width if @viewport_width

    @viewport_width = [IO.console.winsize[1] - 2, MAX_WIDTH].min
    @viewport_width -= 1 - (@viewport_width % 2)
    @viewport_width
  end

  def column_width
    return @column_width if @column_width

    @column_width = (viewport_width - 1) / 2
  end

  LABEL_WIDTH = 8

  def label(text)
    "#{text}:".ljust(LABEL_WIDTH)
  end

  ############################################################################

  def welcome
    hour = Time.now.hour
    greeting = case hour
    when 5..11  then "Good morning"
    when 12..16 then "Good afternoon"
    when 17..20 then "Good evening"
    else             "Good night"
    end
    "#{BOLD}#{greeting}, #{ENV["USER"]}#{RESET}"
  end

  def ruby_version
    "#{CYAN}#{label("Ruby")}#{RESET}#{RUBY_VERSION}"
  end

  def last_login
    output = `last -1 $USER 2>/dev/null`.strip.lines.first.to_s.strip
    value = output.empty? ? "#{GRAY}Unknown#{RESET}" : output.split.last(4).join(" ")
    "#{CYAN}#{label("Login")}#{RESET}#{value}"
  end

  def current_hostname
    "#{CYAN}#{label("Host")}#{RESET}#{BOLD}#{Socket.gethostname}#{RESET}"
  end

  def current_ip
    ip = Socket.ip_address_list.find { |a| a.ipv4_private? }&.ip_address || "unknown"
    "#{CYAN}#{label("IP")}#{RESET}#{GREEN}#{ip}#{RESET}"
  end

  def current_directory
    dir = Dir.pwd.sub(ENV["HOME"], "~")
    "#{CYAN}#{label("Dir")}#{RESET}#{YELLOW}#{dir}#{RESET}"
  end

  def current_git_branch
    branch = `git rev-parse --abbrev-ref HEAD 2>/dev/null`.strip
    value = branch.empty? ? "#{GRAY}Not a git repo#{RESET}" : "#{GREEN}#{branch}#{RESET}"
    "#{CYAN}#{label("Branch")}#{RESET}#{value}"
  end

  def current_time
    "#{CYAN}#{label("Time")}#{RESET}#{Time.now.strftime("%Y-%m-%d %H:%M %Z")}"
  end

  def uptime
    raw = `uptime -p 2>/dev/null || uptime`.strip.split(/,?\s*load/).first.strip
    "#{CYAN}#{label("Uptime")}#{RESET}#{raw}"
  end
end

ShellHeader.new.shell_header