#!/usr/bin/env ruby
# -*- mode: ruby; coding: utf-8 -*-

require "cinch"
require_relative "cinch-plugins/plugins/http_server"
require_relative "cinch-plugins/plugins/github_commits"
require_relative "cinch-plugins/plugins/logplus"
require_relative "cinch-plugins/plugins/echo"

DIR = File.dirname(File.expand_path(__FILE__))

cinch = Cinch::Bot.new do
  configure do
    config.server     = "chat.freenode.net"
    config.port       = 6697
    config.ssl.use    = true
    config.ssl.verify = false

    config.channels = ["#secretmaryo"]
    config.nick   = "furbot"
    config.user   = "furbot"
    config.realname = "Furball Bot Left"
  end

  config.plugins.prefix = "!"
  
  config.plugins.options[Cinch::HttpServer] = {
    :host => "0.0.0.0",
    :port => 46664,
    :logfile => "#{DIR}/tmp/httpserver.log"
  }

   config.plugins.options[Cinch::LogPlus] = {
     :plainlogdir => "#{DIR}/logs/plainlogs",
     :htmllogdir  => "#{DIR}/logs/htmllogs",
     :timelogformat => "%H:%M"
   }

  config.plugins.plugins = [Cinch::Echo,
                            Cinch::HttpServer,
                            Cinch::GithubCommits,
                            Cinch::LogPlus]

  trap "SIGINT" do
    bot.quit
  end

  trap "SIGTERM" do
    bot.quit
  end

  file = File.open("#{DIR}/tmp/bot.log", "a")
  file.sync = true
  loggers.push(Cinch::Logger::FormattedLogger.new(file))
end

cinch.start