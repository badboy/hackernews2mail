HackerNews2Mail
===============

Everyone loves [Hacker News](http://news.ycombinator.com/). And everyone loves mail.
So I just combined the two of them.


What does it do?
================

It just writes all the comments of one thread into a maildir-structured directory
 where you can read it with whatever you want.

For example with mutt:

![hacker-news-in-mutt](http://tmp.fnordig.de/2012-03-03-hacker-news-mutt-mail.png)

What to do?
===========

For now you have to fetch the json containing the post and comments yourself:

    curl http://api.ihackernews.com/post/3657821 > comments.json

and then run the script:

    ruby hn2mail.rb

What do I need for this to work?
================================

Just two gems:

* [mustache](http://rubygems.org/gems/mustache)
* [nokogiri](http://rubygems.org/gems/nokogiri)

License
=======

    "THE BEER-WARE LICENSE" (Revision 42):
    badboy wrote this script. As long as you retain this notice you
    can do whatever you want with this stuff. If we meet some day, and you think
    this stuff is worth it, you can buy me a beer in return. Jan-Erik Rediger
