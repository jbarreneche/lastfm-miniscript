#!/usr/bin/env ruby
# encoding: UTF-8

require 'rockstar'
Rockstar.lastfm = {'api_key' => "07b45818fc5e6741ccbc35ff61c9249f", 'api_secret' => "5dd144b5d660b22f5fafbafce89d26d2"}


write_bands = lambda do |file, data, bands, level|
  break if level == 4
  bands.each do |band|
    next if data[band]

    file.write(band + "\n")
    data[band] = true

    puts " " * level + band
    begin
      similar = Rockstar::Artist.new(band).similar.map(&:name)
      similar.each {|s|  file.write(s + "\n") } 
      write_bands.call(file, data, similar, level + 1)
    rescue EOFError
      data[band] = false
      puts "**** Palmé y espero"
      sleep 10
      retry
    end
  end
end

File.open('artists.txt', 'w') do |f|
  lista_inicial = [
    'Megadeth'
  ]
  arr = {}
  write_bands.call(f, arr, lista_inicial, 0)
  puts arr.inspect
end

