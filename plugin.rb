#!/bin/env ruby
# encoding: utf-8
# name: Discourse Go7 Onebox
# about: Adds support for embedding Go7.ir media within Discourse.
# version: 0.1
# authors: M H
# url: https://github.com/mhosseinab/discourse-go7-onebox

require 'net/http'

Onebox = Onebox

class Onebox::Engine::GoIrOnebox
  include Onebox::Engine
  
  def self.priority
    0
  end
  
  REGEX = /^https?\:\/\/go7.ir\/i\/(\d*)/
  matches_regexp REGEX

  def id
    @url.match(REGEX)[1]
  end
  
  def type
    res = Net::HTTP.start('go7.ir', '80') {|http|
      http.get("/i/#{id}")
    }
    
    if !res['location']
      return false
    end
    
    ext = File.extname(res['location'])
    if ['.mp4'].include? ext
      return 'video'
    
    elsif ['.mp3','.oga'].include? ext
      return 'audio'
    
    elsif ['.pdf','.doc','.docx'].include? ext
      return 'documet'
    
    elsif ['.jpg','.jpeg','.gif','.png'].include? ext
      return 'image'
    
    else
      return 'other'
    end
  end
  
  def to_html
    content_type = type
    
    if !content_type
      return "[Invalid link!]"
    end
    
    if content_type == 'audio'
      return %{
        <audio controls="">
          <source src="https://go7.ir/i/#{id}">
          <a href="https://go7.ir/i/#{id}" rel="nofollow noopener">https://go7.ir/i/#{id}</a>
        </audio>
      }
    elsif content_type == 'video'
      return %{
        <div class="onebox video-onebox go7-onebox">
          <video width="100%" height="100%" controls="">
            <source src="https://go7.ir/i/#{id}">
            <a href="https://go7.ir/i/#{id}" rel="noopener">https://go7.ir/i/#{id}</a>
          </video>
        </div>
      }
    elsif type == 'image'
      return %{
        <p><img src="https://go7.ir/i/#{id}" style="max-width:100% !important" class="d-lazyload"></img></p>
      }
    else
      return %{
        <div class="onebox go7-onebox">
          <a class="attachment" href="https://go7.ir/i/#{id}" rel="noopener">https://go7.ir/i/#{id}</a>
        </div>
      }
    end
  end
end 
