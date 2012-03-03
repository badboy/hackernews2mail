# encoding: utf-8

require 'digest/md5'

class MailTemplate < Mustache
  self.path = File.dirname(__FILE__)

  attr_reader :message_id
  attr_reader :post_id
  attr_reader :parent
  attr_reader :posted_by
  attr_reader :subject

  def initialize args={}
    @_date = args[:date]
    @message_id = args[:message_id]
    @post_id = args[:post_id]
    @parent = args[:parent]
    @posted_by = args[:posted_by]
    @subject = args[:subject]
    @_body = args[:body]
  end

  def date
    @_date.rfc822
  end

  def body
    "#{@_body}\n\n---\nComments at: http://news.ycombinator.com/item?id=#{@post_id}"
  end

  def from
    {
      name: posted_by,
      mail: "#{posted_by}@news.ycombinator.com"
    }
  end

  def to
    user
  end

  def user
    {
      name: 'you',
      mail: 'you@news.ycombinator.com'
    }
  end

  def reply
    if reply?
      { reply_to: "#{parent}" }
    end
  end

  def reply?
    parent && post_id != message_id
  end

  def user_agent_string
    'Hackernews2Mail v0.0.1'
  end

  def filename
    "#{@_date.to_i}_0.#{$$}.#{`hostname`.chomp},U=#{post_id},FMD5=#{Digest::MD5.hexdigest(@posted_by + @_body)}"
  end
end
