#!/usr/bin/env ruby
# encoding: utf-8

require 'mustache'
require 'nokogiri'
require 'time'
require 'json'

require_relative 'mail_template'

NOW = Time.now

def ago_to_date ago_string
  md = ago_string.match(/(\d+) (hour|minute|second)s? ago/)
  if md
    i = md[1].to_i
    case md[2]
    when 'hour'
      NOW - i*60*60
    when 'minute'
      NOW - i*60
    when 'second'
      NOW - i
    else
      NOW
    end
  end
end

def html2plaintext html
  Nokogiri::HTML(html.gsub(/<p>/, "\n\n")).inner_text
end

def render2file info
  mail = MailTemplate.new info

  puts "rendering #{mail.filename}..."

  File.open(File.join(MAIL_OUT, mail.filename), 'w') { |f|
    f.write mail.render
  }
end


JSON_FILE = "./comments.json"
MAIL_OUT = "./mails/new"

full_con = JSON.parse IO.read(JSON_FILE)

thread_body = full_con['url'].empty? ? full_con['text'] : full_con['url']
thread = {
  subject:     full_con['title'],
  body:        html2plaintext(thread_body),
  date:        ago_to_date(full_con['postedAgo']),
  posted_by:   full_con['postedBy'],
  parent:      nil,
  message_id:  full_con['id'],
  post_id:     full_con['id']
}

render2file thread

comments = full_con['comments']

def render_comments subject, comments
  comments.each do |comment|
    comm = {
      subject:     "Re: #{subject}",
      body:        html2plaintext(comment['comment']),
      date:        ago_to_date(comment['postedAgo']),
      posted_by:   comment['postedBy'],
      parent:      comment['parentId'],
      message_id:  comment['id'],
      post_id:     comment['postId']
    }

    render2file comm
    render_comments subject, comment['children']
  end
end

render_comments thread[:subject], comments
